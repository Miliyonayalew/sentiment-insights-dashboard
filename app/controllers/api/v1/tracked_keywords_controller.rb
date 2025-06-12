class Api::V1::TrackedKeywordsController < ApplicationController
    before_action :authenticate_user!

    def index
        render json: current_user.tracked_keywords
    end

    def create
        keyword = current_user.tracked_keywords.create!(keyword_params)
        render json: keyword, status: :created
    end

    def destroy
        current_user.tracked_keywords.find(params[:id]).destroy
        head :no_content
    end

    # POST /tracked_keywords/:id/fetch_mentions
    def fetch_mentions
        keyword = current_user.tracked_keywords.find(params[:id])
        
        # Check if Sidekiq is available
        begin
          Sidekiq::Stats.new
        rescue => e
          return render json: {
            error: "Background job system (Sidekiq) is not available. Please start Sidekiq first.",
            details: "Run 'bundle exec sidekiq' or use './bin/dev-auto' to start all services.",
            sidekiq_error: e.message
          }, status: 503
        end
        
        # Get page_size from params, default to 20 if not provided
        page_size = params[:page_size]&.to_i || 20
        # Ensure page_size is within reasonable limits (1-100)
        page_size = [[page_size, 1].max, 100].min
        
        # Queue the job with page_size parameter
        job = FetchMentionsJob.perform_later(keyword.id, page_size)

        # Broadcast job started notification using ActionCable directly
        ActionCable.server.broadcast(
          "mentions:#{current_user.id}",
          {
            type: 'fetch_started',
            keyword_id: keyword.id,
            keyword: keyword.keyword,
            job_id: job.job_id,
            page_size: page_size
          }
        )

        render json: {
          message: "Fetching mentions started.",
          job_id: job.job_id,
          keyword: keyword.keyword,
          page_size: page_size
        }, status: :accepted
    end

    def mentions
        keyword = current_user.tracked_keywords.find(params[:id])
        render json: keyword.mentions
    end

    # GET /tracked_keywords/:id/relevant_mentions
    def relevant_mentions
        keyword = current_user.tracked_keywords.find(params[:id])
        search_term = keyword.keyword.downcase

        # Filter mentions to only include those with the keyword in title or content
        relevant = keyword.mentions.select do |mention|
          title = mention.title&.downcase || ''
          content = mention.content&.downcase || ''
          title.include?(search_term) || content.include?(search_term)
        end

        render json: relevant
    end

    # GET /tracked_keywords/:id/status
    def status
        keyword = current_user.tracked_keywords.find(params[:id])
        render json: {
          keyword_id: keyword.id,
          keyword: keyword.keyword,
          mentions_count: keyword.mentions.count,
          last_updated: keyword.mentions.maximum(:created_at)
        }
    end

    private

    def keyword_params
        params.require(:tracked_keyword).permit(:keyword)
    end
end
