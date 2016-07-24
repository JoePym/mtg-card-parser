class CardParser
  attr_accessor :file_loc, :name
  attr_reader :response, :title

  class CardParsingError < StandardError; end

  TOP_X = 12
  TOP_Y = 12
  BOTTOM_Y = 21

  def initialize(file_loc:)
    self.file_loc = file_loc
  end

  def parse!
    fetch_ocr_results
    find_card_title
    fetch_card_details
  end

  private

  def fetch_ocr_results
    image = File.read(file_loc)
    request = Google::Apis::VisionV1::AnnotateImageRequest.new(
      image: {content: image},
      features: [{type: "TEXT_DETECTION"}]
    )
    batch = Google::Apis::VisionV1::BatchAnnotateImagesRequest.new(requests: [request])
    result = CloudVision.annotate_image(batch)
    raise CardParsingError, result.responses.first.error.inspect if result.responses.first.error
    @response = result.responses.first
  end

  def fetch_card_details
    MTG::Card.where(name: title).all.first
  end

  def find_card_title
    @title = @response.text_annotations.select do |annotation|
      tl, _tr, bl, _br = annotation.bounding_poly.vertices
      tl.y == TOP_Y && bl.y == BOTTOM_Y
    end.map(&:description).join(" ")
  end
end
