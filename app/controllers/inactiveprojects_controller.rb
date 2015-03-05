
require 'log_file'
class InactiveprojectsController < ApplicationController
  unloadable
  layout 'admin'
  before_filter :require_admin
  before_filter :require_correct_path, :except => [:index]

  include RedmineLogs::LogFile
  
  LOGDIR = "#{Rails.root.to_s}/log"

  def index
    @logs = log_list(LOGDIR)
    @logs.sort{|x, y|x.path <=> y.path}
  end


  def show
    @path = params[:path]
    @log = tail(@path, 20000).join
  end


  def download
    send_file(params[:path])
  end

  def delete
    begin
      File.delete(params[:path])
      redirect_to :action => "index"
    rescue => e
      @error = e
      @logs = log_list(LOGDIR)
      @logs.sort{|x, y|x.path <=> y.path}
      render :action => "index"
    end

  end

  private
  def log_list(path)
    logs = []
    Dir::foreach(path) do |v|
      next if v.start_with?('.') #exlude special path (. and ..) and hidden directories
      if path =~ /\/$/
        v = path + v
      else
        v = path + "/" + v
      end
      
      if FileTest::directory?(v)
        logs = logs + log_list(v)
      else
        logs << LogFile.new(v)
      end
    end
    logs
  end

  def require_correct_path
    path = File.expand_path(params[:path])
    unless path.start_with? LOGDIR
      render_403
      return false
    end
    true
  end

  # copy from http://www.hirax.net/diaryweb/2010/03/02.html
  def tail(filename,readLength)
    ary=[]
    f=File.open(filename)
    begin
      f.seek(-readLength,IO::SEEK_END)
    rescue
    end
    while f.gets
      ary<<$_
    end
    f.close
    return ary
  end

end
