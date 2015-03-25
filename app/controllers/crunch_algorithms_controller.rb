require 'json'

class CrunchAlgorithmsController < ApplicationController
  before_action :set_crunch_algorithm, only: [:show, :edit, :update, :destroy]

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
    @allowed_functions = CrunchAlgorithm::ALLOWED_FUNCTIONS
  end

  # POST /crunch_algorithms
  # POST /crunch_algorithms.json
  def create
    @crunch_algorithm = CrunchAlgorithm.new(crunch_algorithm_params)

    respond_to do |format|
      if @crunch_algorithm.save && @crunch_algorithm.set_dimensions
        format.html { redirect_to @crunch_algorithm, notice: 'Crunch algorithm was successfully created.' }
        format.json { render :show, status: :created, location: @crunch_algorithm }
      else
        format.html { render :new }
        format.json { render json: @crunch_algorithm.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_dimensions
    self.dimensions = self.data_source.dimension_translations.map {|dt| {name: dt[:translated_name], data_type: dt[:data_type]}}
    self.save
  end

  # PATCH/PUT /crunch_algorithms/1
  # PATCH/PUT /crunch_algorithms/1.json
  def update
    functions = params[:functions]
    parsed_functions = []
    functions.each do |number, func|
      parsed_functions << {name: func[:name].to_sym, args: eval(func[:args])} if func[:name] != ""
    end
    @crunch_algorithm.functions = parsed_functions
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
      params.require(:crunch_algorithm).permit(:name, :functions, :category, :report_id)
    end
end
