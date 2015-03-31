require 'json'

class CrunchAlgorithmsController < ApplicationController
  before_action :set_crunch_algorithm, only: [:show, :edit, :update, :destroy, :edit_functions, :update_function_settings, :function_settings, :get_form]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  # GET /crunch_algorithms
  # GET /crunch_algorithms.json
  def index
    @crunch_algorithms = CrunchAlgorithm.all
  end

  # GET /crunch_algorithms/1
  # GET /crunch_algorithms/1.json
  def show
  end

  # GET /crunch_algorithms/new
  def new
    @allowed_functions = CrunchAlgorithm::ALLOWED_FUNCTIONS
    @crunch_algorithm = CrunchAlgorithm.new
    @crunch_algorithm.functions = []
  end

  # GET /crunch_algorithms/1/edit
  def edit
  end

  # POST /crunch_algorithms
  # POST /crunch_algorithms.json
  def create
    @crunch_algorithm = CrunchAlgorithm.new(crunch_algorithm_params)

    respond_to do |format|
      if @crunch_algorithm.save && @crunch_algorithm.set_dimensions
        format.html { redirect_to edit_functions_path(:id =>@crunch_algorithm.id), :notice => 'Crunch algorithm succesfully created' }
        format.json { render :show, status: :created, location: @crunch_algorithm }
      else
        format.html { render :new }
        format.json { render json: @crunch_algorithm.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit_functions
    @allowed_functions = CrunchAlgorithm::ALLOWED_FUNCTIONS
  end

  # PATCH/PUT /crunch_algorithms/1
  # PATCH/PUT /crunch_algorithms/1.json
  def update
    respond_to do |format|
      if @crunch_algorithm.update(crunch_algorithm_params)
        format.html { redirect_to @crunch_algorithm, notice: 'Crunch algorithm was successfully updated.' }
        format.json { render :show, status: :ok, location: @crunch_algorithm }
      else
        format.html { render :edit }
        format.json { render json: @crunch_algorithm.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_form
    function_name = params[:func]
    function = function_name.capitalize.constantize
    render html: function.form(@crunch_algorithm).html_safe
  end

  def delete_function
    function_index = params[:func_index]
    render json: {success: true}
  end

  def function_settings
    render json: @crunch_algorithm.function_settings.to_json
  end  

  def update_function_settings
    @crunch_algorithm.function_settings = JSON.parse(request.body.read)["functions"]
    @crunch_algorithm.save
  end

  # DELETE /crunch_algorithms/1
  # DELETE /crunch_algorithms/1.json
  def destroy
    @crunch_algorithm.destroy
    respond_to do |format|
      format.html { redirect_to crunch_algorithms_url, notice: 'Crunch algorithm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crunch_algorithm
      @crunch_algorithm = CrunchAlgorithm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crunch_algorithm_params
      params.permit(:name, :functions, :category, :report_id, :data_source_id, :number, :function_settings)
    end
end
