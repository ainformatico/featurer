# frozen_string_literal: true

module FeaturerHelper
  def featurer_head_tag(value)
    render partial: 'featurer/head_tag', locals: { value: value }
  end
end
