class RetrieveBooksWorker < BaseUserWorker
  private

  def initialize_variables(author)
    @author = author
  end

  def perform_args
    [@author]
  end

  def service
    :retrieve_books
  end

  def attempt
    "retrieving books with author: #{@author}"
  end
end
