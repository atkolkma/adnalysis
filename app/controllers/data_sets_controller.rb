class DataSetsController < ApplicationController
  before_action :set_data_set, only: [:show, :edit, :update, :destroy]

  # GET /data_sets
  # GET /data_sets.json
  def index
    @data_sets = DataSet.all
  end

  # GET /data_sets/1
  # GET /data_sets/1.json
  def show
  end

  # GET /data_sets/new
  def new
    # @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/new/${filename}", success_action_status: 201, acl: :public_read)
    @data_set = DataSet.new
  end

  # GET /data_sets/1/edit
  def edit
  end

  # POST /data_sets
  # POST /data_sets.json
  def create
    uploaded_file = data_set_params[:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') {|file| file.write(uploaded_file.read)}
    uploaded_file_location = Rails.root.join('public', 'uploads', uploaded_file.original_filename)
    @data_set = DataSet.new(data_set_params.except(:file).merge(file_names: [uploaded_file.original_filename]))
    @data_set.store_data(uploaded_file_location)

    # upload(@data_set, uploaded_file)

    respond_to do |format|
      if @data_set.save
        format.html { redirect_to @data_set, notice: 'Data set was successfully created.' }
        format.json { render :show, status: :created, location: @data_set }
      else
        format.html { render :new }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload(data_set, file)
    uploaded_io = file
    opened_file = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    data_set.store_data(opened_file)
    redirect_to @data_set
  end

  # PATCH/PUT /data_sets/1
  # PATCH/PUT /data_sets/1.json
  def update
    respond_to do |format|
      if @data_set.update(data_set_params)
        format.html { redirect_to @data_set, notice: 'Data set was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_set }
      else
        format.html { render :edit }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sets/1
  # DELETE /data_sets/1.json
  def destroy
    @data_set.destroy
    respond_to do |format|
      format.html { redirect_to data_sets_url, notice: 'Data set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_data_set
      @data_set = DataSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_set_params
      params.require(:data_set).permit(:name, :file, file_names:[], source_files: [])
    end
end
