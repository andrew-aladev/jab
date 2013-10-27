###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir,    "css"
set :js_dir,     "js"
set :images_dir, "img"

configure :build do
  ignore "js/src/*"
  ignore "css/src/*"
  
  require "yui/compressor"
  activate :minify_css
  set :css_compressor, ::YUI::CssCompressor.new

  require "closure-compiler"
  activate :minify_javascript
  set :js_compressor, ::Closure::Compiler.new

  activate :minify_html

  activate :image_optim do |options|
    options[:verbose] = true
    options[:nice]    = true
    options[:threads] = true

    options[:image_extensions] = [".png", ".jpg", ".gif"]

    options[:pngcrush]  = {:chunks => ["alla"], :fix => true, :brute => true}
    options[:pngout]    = false
    options[:optipng]   = {:level => 7, :interlace => false}
    options[:advpng]    = {:level => 4}
    options[:jpegoptim] = {:strip => ["all"], :max_quality => 90}
    options[:jpegtran]  = {:copy_chunks => false, :progressive => true, :jpegrescan => true}
    options[:gifsicle]  = {:interlace => false}
  end

  # Use relative URLs
  # activate :relative_assets
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method       = :git
  deploy.remote       = "live"
  deploy.branch       = "master"
end
