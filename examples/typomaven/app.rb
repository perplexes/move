require 'move'
class TypoMaven < Move::Application
  def initialize
    @associations = {'typos' => Typo} #XXX: Hmm.
    super
  end
  
  def typos(request)
    CollectionView.new(self, Typo.all)
  end
end