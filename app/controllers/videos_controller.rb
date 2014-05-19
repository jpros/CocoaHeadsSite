class VideosController < ApplicationController

  before_action :confirm_logged_in, except: [:todos]
  before_action :set_video, only: [:show, :edit, :update, :destroy, :detalhes]
  before_action :find_palestrante, :except => [:useful]

  layout 'admin'

  # GET /videos
  # GET /videos.json
  def index
    @videos = @palestrante.videos.mais_novos
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new({:palestrante_id => @palestrante.id})
    @palestrantes = Palestrante.ordenados
    @agendas = Agenda.recentes
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
    @palestrantes = Palestrante.ordenados
    @agendas = Agenda.recentes
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|

      if @video.save
        format.html {
          flash[:notice] = "Vídeo criado!."
          redirect_to(:action => 'show', :id => @video.id, :palestrante_id => @palestrante.id)
        }
        format.json { 
          render action: 'show', :palestrante_id => @palestrante.id, status: :created, location: @video
        }
      else
        format.html {
          @palestrantes = Palestrante.ordenados
          @agendas = Agenda.recentes
          render action: 'new'
        }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { 
          flash[:notice] = "Vídeo atualizado!"
          redirect_to(:action => 'show', :id => @video.id, :palestrante_id => @palestrante.id)
        }
        format.json { head :no_content }
      else
        format.html { 
          @palestrantes = Palestrante.order('nome ASC')
          render action: 'edit' 
        }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_path({:palestrante_id => @palestrante.id}) }
      format.json { head :no_content }
    end
  end

  def todos
    @videos = Video.mais_novos.paginate(:page => params[:page])
    render layout: "internal"
  end

  def detalhes
    render layout: "internal"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:titulo, :palestrante_id, :agenda_id, :descricao, :source, :youtube, :published, :tags)
    end

    def find_palestrante
      if params[:palestrante_id]
        @palestrante = Palestrante.find(params[:palestrante_id])
      end
    end
end
