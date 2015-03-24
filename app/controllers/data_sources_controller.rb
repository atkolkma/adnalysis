class DataSourcesController < ApplicationController
  before_action :set_data_source, only: [:show, :edit, :update, :destroy]

  # GET /data_sources
  # GET /data_sources.json
  def index
    @data_sources = DataSource.all
  end

  # GET /data_sources/1
  # GET /data_sources/1.json
  def show
  end

  # GET /data_sources/new
  def new
    @allowed_data_types = DataSource::ALLOWED_DATA_TYPES
    @data_source = DataSource.new
    @data_source.dimension_translations = [{original_name: "clicks", translated_name: "clicks", data_type: "integer"}]

  end

  # GET /data_sources/1/edit
  def edit
    @allowed_data_types = DataSource::ALLOWED_DATA_TYPES
  end

  # POST /data_sources
  # POST /data_sources.json
  def create
    @data_source = DataSource.new(data_source_params)
    
    dimension_translations = params[:dimension_translations]
    parsed_dimension_translations = []
    dimension_translations.each do |number, trans|
      parsed_dimension_translations << {original_name: trans[:original_name].to_sym, translated_name: trans[:translated_name], data_type: trans[:data_type]} if trans[:original_name] != ""
    end

    @data_source.dimension_translations = parsed_dimension_translations

    respond_to do |format|
      if @data_source.save
        format.html { redirect_to @data_source, notice: 'Data source was successfully created.' }
        format.json { render :show, status: :created, location: @data_source }
      else
        format.html { render :new }
        format.json { render json: @data_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_sources/1
  # PATCH/PUT /data_sources/1.json
  def update
    dimension_translations = params[:dimension_translations]
    parsed_dimension_translations = []
    dimension_translations.each do |number, trans|
      parsed_dimension_translations << {original_name: trans[:original_name].to_sym, translated_name: trans[:translated_name], data_type: trans[:data_type]} if trans[:original_name] != ""
    end

    @data_source.dimension_translations = parsed_dimension_translations


    respond_to do |format|
      if @data_source.update(data_source_params)
        format.html { redirect_to @data_source, notice: 'Data source was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_source }
      else
        format.html { render :edit }
        format.json { render json: @data_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sources/1
  # DELETE /data_sources/1.json
  def destroy
    @data_source.destroy
    respond_to do |format|
      format.html { redirect_to data_sources_url, notice: 'Data source was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_source
      @data_source = DataSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_source_params
      params.require(:data_source).permit(:name, dimension_translations: [])
    end
end