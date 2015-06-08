# coding: utf-8
class TopController < ApplicationController
  skip_before_action :authenticate

  # トップ
  def index
    render 'top' unless signed_in?
  end
end
