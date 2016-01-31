class Admin::HrefsController < ApplicationController
  before_filter :setup_madeleine

  def index
    @hrefs = Href.order('created_at DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def train_good
    href = Href.find(params[:href_id])
    href.update_column(:good, true)

    @m.system.train_good(href.url)
    @m.take_snapshot

    redirect_to :action => :index
  end

  def train_bad
    href = Href.find(params[:href_id])
    href.update_column(:good, false)

    @m.system.train_bad(href.url)
    @m.take_snapshot

    redirect_to :action => :index
  end

  protected
  def setup_madeleine
    @m = SnapshotMadeleine.new('bayes_data') {
      Classifier::Bayes.new 'good', 'bad'
    }
  end
end
