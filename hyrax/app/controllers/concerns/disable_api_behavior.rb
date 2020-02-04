# Temporarily disable API behaviour, see https://github.com/antleaf/nims-mdr-development/issues/241

module DisableApiBehavior
  def show
    respond_to do |format|
      format.html { super }
      format.json { render json: { error: 'API is currently unavailable' }, status: 400 }
      format.any { render plain: 'API is currently unavailable', content_type: 'text/plain', status: 400}
    end
  end

  def index
    respond_to do |format|
      format.html { super }
      format.json { render json: { error: 'API is currently unavailable' }, status: 400 }
      format.any { render plain: 'API is currently unavailable', content_type: 'text/plain', status: 400}
    end
  end
end
