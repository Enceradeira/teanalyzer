require File.expand_path('./../../app/teanalyzer', __FILE__)

describe 'Teanalyzer' do
  subject { Teanalyzer }
  describe 'compare effort of words' do
    # some subjective examples using the standard parameter settings
    specify { subject.calculate('Nerd') > subject.calculate('asdfjkl') }
    specify { subject.calculate('peeping') > subject.calculate('pedestal') }
    specify { subject.calculate('scalawag') > subject.calculate('scabbard') }
    specify { subject.calculate('Velcro') > subject.calculate('yashmak') }
    specify { subject.calculate('unethical') > subject.calculate('unenviable') }
    specify { subject.calculate('marquee') > subject.calculate('marooned') }
    specify { subject.calculate('harry') > subject.calculate('haste') }
    specify { subject.calculate('yet') > subject.calculate('has') }
    specify { subject.calculate('dress') > subject.calculate('drench') }
  end
end