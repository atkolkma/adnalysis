class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  before_filter :normalize_source_files_params, :only => [:create, :update, :edit]

  def crunch
    @report = Report.find(params[:id])
    @report.load_data
    @sort_rules = [{dimension: 'adgroup', direction: "asc"}, {dimension: 'match_type', direction: "asc"}, {dimension: 'converted_clicks', direction: "desc"}, {dimension: 'cost', direction: "asc", conversion: ".to_f"}]
    @report_name = @report.name
    @report.report_preview_rows = @report.data.filter_rows.group_by_dimensions(["adgroup", "match_type"]).sort(@sort_rules).truncate(100)
    @report.save
    @metrics = []
    # @metrics = Calculation.frequency_of_unordered_n_tuples(2, report.data)
  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report.data
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    report_params[:source_files] = ['asdads']

    ap report_params
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
    report_params[:source_files] = ['asdads']
      
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def report_params
      params.require(:report).permit(:name, :data_set_id, :crunch_algorithm_id)
    end

    def normalize_source_files_params
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    # def report_params
    #   params[:report]
    # end
end
