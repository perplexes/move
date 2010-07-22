class TypoMaven < Move::Application
  def typos(request)
    CollectionView.new(self, Typo.all)
  end
end