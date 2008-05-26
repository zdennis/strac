class SiteRenderer < Renderer
  def show_notice message
    page[:notice].replace_html message
    page[:error].hide
    page[:notice].show
    page.visual_effect :appear, :notice
    page.delay( 5 ) {  page.visual_effect :fade, :notice }
  end
end