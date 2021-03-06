class CidadesController < ApplicationController

  before_action :confirm_logged_in, except: [:todas, :detalhes]
  before_action :set_cidade, only: [:show, :edit, :update, :destroy, :detalhes]
  before_action :find_estado

  layout 'admin'

  # GET /cidades
  # GET /cidades.json
  def index
    @cidades = Cidade.all
  end

  # GET /cidades/1
  # GET /cidades/1.json
  def show
  end

  # GET /cidades/new
  def new
    @cidade = Cidade.new
    @estados = Estado.ordenados
  end

  # GET /cidades/1/edit
  def edit
    @estados = Estado.ordenados
  end

  # POST /cidades
  # POST /cidades.json
  def create
    @cidade = Cidade.new(cidade_params)
    respond_to do |format|
      if @cidade.save
        format.html { redirect_to @cidade, notice: 'Cidade was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cidade }
      else
        @estados = Estado.ordenados
        format.html { render action: 'new' }
        format.json { render json: @cidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cidades/1
  # PATCH/PUT /cidades/1.json
  def update
    respond_to do |format|
      if @cidade.update(cidade_params)
        format.html { redirect_to @cidade, notice: 'Cidade was successfully updated.' }
        format.json { head :no_content }
      else
        @estados = Estado.ordenados
        format.html { render action: 'edit' }
        format.json { render json: @cidade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cidades/1
  # DELETE /cidades/1.json
  def destroy
    @cidade.destroy
    respond_to do |format|
      format.html { redirect_to({:action => "index"}) }
      format.json { head :no_content }
    end
  end

  def todas
    @cidades = Cidade.por_estado.publicados
    @estados = Estado.all
    respond_to do |format|
      format.html { render layout: "internal" }
      format.json { render json: @cidades }
    end
  end

  def detalhes
    render layout: "internal"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cidade
      @cidade = Cidade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cidade_params
      params.require(:cidade).permit(:cidade, :estado_id, :organizador, :organizador_email, :organizador_contato, :email, :website, :github, :twitter, :facebook, :descricao, :published)
    end

    def find_estado
      if params[:estado_id]
        @estado = Estado.find(params[:estado_id])
      end
    end
end
