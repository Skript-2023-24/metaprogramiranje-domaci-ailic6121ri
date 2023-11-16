require 'google_drive'
require_relative 'novaBiblioteka'

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config('config.json')

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
ws = session.spreadsheet_by_key('1u90sP2-2ParcIAY3o-A1ub8TW_cAXYuqzNELaANS3AY').worksheets[0]

sheetKljuc1 = '1u90sP2-2ParcIAY3o-A1ub8TW_cAXYuqzNELaANS3AY'.freeze
#sheetKljuc2 = '1PmA3rbGLEdZsM9e_r0XfhHmVmTa99HYjr9JpvWBjTqY'

t = GoogleSheetBiblioteka

tabela1 = []
#tabela2 = []

tabela1 = GoogleSheetBiblioteka.ucitaj_iz_google_sheeta(sheetKljuc1)
#tabela2 = GoogleSheetBiblioteka.ucitaj_iz_google_sheeta(sheetKljuc2)

GoogleSheetBiblioteka.ispisi_tabelu(tabela1)

p red = t.row(1)

p celije = t.izdvoji_celije

p kolona = t.column(1)

#p GoogleSheetBiblioteka.drugaKolona.sum

#p GoogleSheetBiblioteka.drugaKolona.map { |cell| cell+=1 }

#p GoogleSheetBiblioteka.saberi_tablice(tabela1,tabela2)

#p GoogleSheetBiblioteka.oduzmi_tablice(tabela1,tabela2)