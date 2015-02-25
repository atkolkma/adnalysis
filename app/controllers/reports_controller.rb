class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :crunch]
  before_filter :normalize_source_files_params, :only => [:create, :update, :edit]

  def crunch
    @report.load_data
    # @sort_rules = [{dimension: 'adgroup', direction: "asc"}, {dimension: 'match_type', direction: "desc"}, {dimension: 'converted_clicks', direction: "desc"}, {dimension: 'cost', direction: "asc", conversion: ".to_f"}]
    # @algorithm = [{name: :filter_rows, args: 0},{name: :group_by_dimensions, args: ["adgroup", "match_type"]},{name: :sort_by_dim, args: @sort_rules},{name: :truncate, args: 100}]
    # @report.crunch_algorithm.functions = @algorithm
    # @report.crunch_algorithm.save
    @report.report_preview_rows = ReportCruncher.crunch(@report.data, @report.crunch_algorithm.functions) #ReportCruncher.truncate(ReportCruncher.sort_by_dim(ReportCruncher.group_by_dimensions(ReportCruncher.filter_rows(@report.data, 0), ["adgroup", "match_type"]), @sort_rules),100)
    @report.save
  end

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
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
      params.require(:report).permit(:name, :data_set_id, :crunch_algorithm_id, :report_preview_rows)
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
