# frozen_string_literal: true

module CustomizedError
  # File does not exist
  class FileDoesNotExistError < StandardError
    def initialize(message = 'File does not exist')
      super(message)
    end
  end

  # File is empty
  class FileIsEmptyError < StandardError
    def initialize(message = 'File is empty')
      super(message)
    end
  end
end
