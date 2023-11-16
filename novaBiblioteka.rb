require 'google_drive'

module GoogleSheetBiblioteka
  #Pakijem kljuc radi preglednosti
  SPREADSHEET_KEY = '1u90sP2-2ParcIAY3o-A1ub8TW_cAXYuqzNELaANS3AY'.freeze

  def self.ucitaj_iz_google_sheeta(key, worksheet_index = 0)
    session = GoogleDrive::Session.from_config('config.json')
    ws = session.spreadsheet_by_key(SPREADSHEET_KEY).worksheets[worksheet_index]

    tabela = []
    ws.rows.each do |row|
      next if row.join(' ').downcase.include?('total') || row.join(' ').downcase.include?('subtotal') || row.all?(&:nil?) || row.all?(&:empty?)
      tabela << row
    end

    tabela
  end

  def self.ispisi_tabelu(tabela)
    tabela.each do |red|
      puts red.join("\t")
    end
  end

  def self.row(redni_broj)
    # Izdvaja samo jedan red iz učitane tabele
    ucitana_tabela = ucitaj_iz_google_sheeta(SPREADSHEET_KEY)
    ucitana_tabela[redni_broj-1]
  end

  def self.column(indeks_kolone)
    ucitana_tabela = ucitaj_iz_google_sheeta(SPREADSHEET_KEY)
    ucitana_tabela.map { |kolona| kolona[indeks_kolone - 1]}.compact
  end

  def self.izdvoji_celije
    ucitana_tabela = ucitaj_iz_google_sheeta(SPREADSHEET_KEY)
    sve_celije = []

    ucitana_tabela.each do |red|
      red.each do |celija|
          sve_celije << celija
      end
    end

    sve_celije
  end

  class Kolona
    def initialize(data)
      @data = data
    end

    def map(&block)
      @data.map(&block)
    end

    def select(&block)
      @data.select(&block)
    end

    def reduce(initial = nil, &block)
      @data.reduce(initial, &block)
    end
  end

  def self.sum(indeks_kolone)
    kolona = column(indeks_kolone)
    kolona.sum if kolona.any?
  end

  def self.avg(indeks_kolone)
    kolona = column(indeks_kolone)
    kolona.sum if kolona.any?
  end

  def self.saberi_tablice(tabela1, tabela2)
    return nil unless tabela1[0] == tabela2[0] # Provera da li imaju iste header-e

    tabela1 + tabela2[1..-1] # Spajanje tabela tako da se redovi druge tabele dodaju na kraj prve tabele (bez header-a)
  end

  def self.oduzmi_tablice(tabela1, tabela2)
    return nil unless tabela1[0] == tabela2[0] # Provera da li imaju iste header-e

    header = tabela1[0]
    nova_tabela = [header]

    tabela1.each_with_index do |red1, index1|
      next if index1.zero? # Preskakanje prvog reda (header)

      duplicate = false

      tabela2.each_with_index do |red2, index2|
        next if index2.zero? # Preskakanje prvog reda (header)

        if red1 == red2
          duplicate = true
          break
        end
      end

      nova_tabela << red1 unless duplicate
    end

    nova_tabela
  end

  def self.get_row_by_value(column_index, value)
    ucitana_tabela = ucitaj_iz_google_sheeta(SPREADSHEET_KEY)
    redovi = ucitana_tabela.transpose

    index = redovi[column_index - 1].index(value)
    return nil if index.nil?

    ucitana_tabela[index]
  end

  def self.prvaKolona
    return column(1)
  end

  def self.drugaKolona
    return column(2)
  end

  def self.trecaKolona
    return column(3)
  end

  extend self

  def [](input_string)
    # Implementacija čitanja vrednosti iz uglastih zagrada
    puts "Vrednost između uglastih zagrada: #{input_string}"

    case input_string.downcase
    when "prvakolona"
      return column(1)
    when "drugakolona"
      return column(2)
    when "trecakolona"
      return column(3)
    else
      if input_string.match?(/t.indeks\.rn\d+/)
        parts = input_string.split('.')
        index = parts[1][2..-1].to_i # dobijamo broj (npr. 2310) iz stringa rn2310
        return get_row_by_value(parts[0][-1].to_i, index)
      else
        puts "Nepoznata sintaksa!"
        return nil
      end
    end
  end

end
