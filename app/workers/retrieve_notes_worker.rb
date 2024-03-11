class RetrieveNotesWorker < BaseUserWorker
  include Sidekiq::Worker

  private

  def initialize_variables(author)
    @author = author
  end

  def perform_args
    [@author]
  end

  def service
    :retrieve_notes
  end

  def attempt
    "retrieving book notes with author: #{@author}"
  end
end
