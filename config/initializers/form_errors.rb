ActionView::Base.field_error_proc = proc do |html_tag, instance|
  render 'application/form_errors',
         html_tag:, instance:
end
