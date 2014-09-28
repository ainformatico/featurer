require "rspec/core/formatters/progress_formatter"

class FastFeedbackFormatter < RSpec::Core::Formatters::ProgressFormatter
  def example_failed(example)
    super(example)

    example_group = example.metadata[:example_group]

    output.puts ""
    output.puts red("#{example_group[:file_path]}:#{example_group[:line_number]}")
    output.puts red(example.execution_result[:exception].to_s.strip)
  end
end
