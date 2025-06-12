class Api::V1::HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def sidekiq_status
    begin
      # Check if Sidekiq is running by accessing its stats
      stats = Sidekiq::Stats.new
      render json: {
        status: 'running',
        processed: stats.processed,
        failed: stats.failed,
        busy: stats.workers_size,
        enqueued: stats.enqueued,
        scheduled: stats.scheduled_size,
        dead: stats.dead_size,
        processes: stats.processes_size
      }
    rescue => e
      render json: {
        status: 'not_running',
        error: e.message
      }, status: 503
    end
  end

  def system_status
    begin
      stats = Sidekiq::Stats.new
      sidekiq_running = true
    rescue
      sidekiq_running = false
    end

    render json: {
      rails: 'running',
      sidekiq: sidekiq_running ? 'running' : 'not_running',
      database: database_status,
      background_jobs_ready: sidekiq_running
    }
  end

  private

  def database_status
    ActiveRecord::Base.connection.active? ? 'connected' : 'disconnected'
  rescue
    'disconnected'
  end
end
