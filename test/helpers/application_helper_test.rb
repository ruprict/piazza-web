# frozen_string_literal: true

class ApplicationHelperTest < ActionView::TestCase
  setup do
    @turbo_native_app = false
  end

  test 'formats page specific title' do
    content_for(:title) { 'Page Title' }

    assert_equal "Page Title | #{I18n.t('piazza')}", title
  end

  test 'returns app name when title missing' do
    assert_equal I18n.t('piazza'), title
  end

  private

  def turbo_native_app?
    @turbo_native_app
  end
end
