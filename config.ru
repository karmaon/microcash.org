require 'bundler'
Bundler.require(:default)

require 'rack/contrib/try_static'

# Redirect to www in production
if ENV['RACK_ENV'] == 'production'
  require 'rack/rewrite'
  use Rack::Rewrite do
    r301 /.*/, Proc.new { |path, rack_env|
      "http://www.#{rack_env['SERVER_NAME']}#{path}" },
        :if => Proc.new { |rack_env| rack_env['SERVER_NAME'] !~ /www\./i
    }
  end
end

use Rack::TryStatic, 
    :root => 'public',
    :urls => %w[/],
    :try => ['index.html']

run lambda { |env|
  [
    404,
    {
      'Content-Type' => 'text/html'
    },
    ['File not found']
  ]
}