# This template installs the new jQuery drivers, removes
# the old prototype drivers, and installs an initializer
# which overrides the javascript_include_tag to include
# jQuery and the new drivers with :default
# Written by: Logan Leger, logan@loganleger.com
# http://github.com/lleger/Rails-3-jQuery

# Deleting old prototype drivers
# Do this first so that you don't delete the new jQuery rails one below
inside('public/javascripts') do
	run "rm -rf controls.js dragdrop.js effects.js prototype.js rails.js"
end

# Downloading latest jQuery.min
get "http://code.jquery.com/jquery-latest.min.js", "public/javascripts/jquery.js"

# Downloading latest jQuery drivers
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

# Overriding javascript_include_tag to include new jQuery js
initializer 'jquery.rb', <<-CODE
# Switch the javascript_include_tag :defaults to use jQuery instead of
# the default prototype helpers.
# Credits: http://webtech.union.rpi.edu/blog/2010/02/21/jquery-and-rails-3/

# Override the javascript defaults once ActionView is loaded and the app has been initialized.
# Otherwise ActionView's railtie initializer will overwrite our changes.
ActiveSupport.on_load(:action_view) do
  ActiveSupport.on_load(:after_initialize) do
    ActionView::Helpers::AssetTagHelper.javascript_expansions.clear
    ActionView::Helpers::AssetTagHelper::register_javascript_expansion :defaults => ['jquery', 'rails']
  end
end
CODE