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
        FetchMentionsJob.perform_later(keyword.id)
        render json: { message: "Fetching mentions started." }, status: :accepted
    end

    private

    def keyword_params
        params.require(:tracked_keyword).permit(:keyword)
    end
end
