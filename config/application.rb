require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KanbanCoreExtension
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(
      #{Rails.root}/domain
      #{Rails.root}/project
      #{Rails.root}/feature
      #{Rails.root}/kanban
    )

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # action_view field_error_proc
    config.action_view.field_error_proc = proc {|html_tag, instance| "<div class='has-error'>#{html_tag}</div>".html_safe }
  end
end
