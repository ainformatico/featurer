# frozen_string_literal: true
require 'rspec/core/formatters/progress_formatter'

class FastFeedbackFormatter < RSpec::Core::Formatters::ProgressFormatter
  def example_failed(example)
    super(example)

    print_formatted_example(example.metadata[:example_group])
  end

  private

  def print_formatted_example(example_group)
    output.puts ''
    output.puts red("#{example_group[:file_path]}:#{example_group[:line_number]}")
    output.puts red(example.execution_result[:exception].to_s.strip)
  end
end
