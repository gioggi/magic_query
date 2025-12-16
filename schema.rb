# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_251_203_114_555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'ade_infos', force: :cascade do |t|
    t.bigint 'medico_id', null: false
    t.string 'cf', null: false
    t.boolean 'delega_fatturazione', default: false
    t.boolean 'delega_cassetto', default: false
    t.boolean 'to_sync', default: true
    t.string 'sections_to_sync', default: [], array: true
    t.jsonb 'dichiarazioni', default: []
    t.jsonb 'sette_trenta', default: []
    t.jsonb 'cu', default: []
    t.jsonb 'f24', default: []
    t.jsonb 'fatture_elettroniche', default: []
    t.jsonb 'registro', default: []
    t.jsonb 'catasto', default: {}
    t.boolean 'errore', default: false
    t.string 'descrizione_errore'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.datetime 'last_sync'
    t.jsonb 'last_sync_sections', default: {}
    t.boolean 'deceduto', default: false
    t.index ['cf'], name: 'index_ade_infos_on_cf'
    t.index ['medico_id'], name: 'index_ade_infos_on_medico_id'
  end

  create_table 'admins', force: :cascade do |t|
    t.string 'nome'
    t.string 'cognome'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_admins_on_user_id'
  end

  create_table 'analisis', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.jsonb 'incassato', default: { 'data_aggiornamento' => nil }
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_analisis_on_user_id'
  end

  create_table 'articolos', force: :cascade do |t|
    t.text 'url'
    t.text 'titolo', default: ''
    t.text 'testo_html', default: ''
    t.text 'testo', default: ''
    t.datetime 'data_aggiornamento'
    t.text 'nome_img_s3', default: ''
    t.text 'miniatura_base64', default: ''
    t.bigint 'priorita', default: 0
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.bigint 'commercialista', default: 0
    t.text 'descrizione'
    t.index ['url'], name: 'idx_38737_index_articolos_on_url', unique: true
  end

  create_table 'articolos_tag_blogs', id: false, force: :cascade do |t|
    t.bigint 'articolo_id'
    t.bigint 'tag_blog_id'
    t.index %w[articolo_id tag_blog_id], name: 'idx_38758_index_articolos_tag_blogs_on_articolo_id_and_tag_blog'
    t.index %w[tag_blog_id articolo_id], name: 'idx_38758_index_articolos_tag_blogs_on_tag_blog_id_and_articolo'
  end

  create_table 'autofattura_f24s', force: :cascade do |t|
    t.integer 'user_id'
    t.integer 'fattura_id'
    t.string 'uuid'
    t.string 'tipologia'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['fattura_id'], name: 'index_autofattura_f24s_on_fattura_id'
  end

  create_table 'clientes', force: :cascade do |t|
    t.bigint 'user_id'
    t.text 'ragione_sociale'
    t.text 'partita_iva'
    t.text 'codice_fiscale'
    t.text 'cap'
    t.text 'comune'
    t.text 'indirizzo'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.boolean 'ente_pubblic', default: false
    t.text 'codice_pa'
    t.text 'codice_sdi', default: '0000000'
    t.text 'pec'
    t.boolean 'p_amministrazione', default: false
    t.boolean 'idoneo_elettronica', default: false
    t.text 'role', default: 'persona'
    t.text 'cig'
    t.text 'cup'
    t.text 'nazione', default: 'IT'
    t.text 'provincia'
    t.boolean 'cancellato', default: false
    t.string 'email'
    t.index ['user_id'], name: 'idx_38642_index_clientes_on_user_id'
  end

  create_table 'commercialista', force: :cascade do |t|
    t.string 'nome'
    t.string 'cognome'
    t.bigint 'user_id', null: false
    t.boolean 'uomo'
    t.boolean 'riceve_nuovi_clienti', default: true
    t.boolean 'test_account', default: false
    t.boolean 'operation', default: false
    t.string 'link_consulenza'
    t.string 'tag_mailchimp'
    t.string 'mandrill_template'
    t.boolean 'partecipante_fiscobisca', default: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'stripe_account_id'
    t.string 'vat_code'
    t.string 'address'
    t.string 'zipcode'
    t.string 'city'
    t.string 'country', default: 'IT'
    t.string 'province'
    t.string 'fiscal_code'
    t.datetime 'vat_opening_date'
    t.string 'suffix'
    t.string 'fiscal_name'
    t.index ['user_id'], name: 'index_commercialista_on_user_id'
  end

  create_table 'credenzialits', force: :cascade do |t|
    t.bigint 'user_id'
    t.text 'cf'
    t.text 'password'
    t.text 'pincode'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.index ['user_id'], name: 'idx_38697_index_credenzialits_on_user_id'
  end

  create_table 'declaration_answer_files', force: :cascade do |t|
    t.bigint 'dichiarazione_id', null: false
    t.string 'stage_name', null: false
    t.integer 'question_number', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[dichiarazione_id stage_name question_number],
            name: 'index_declaration_answer_files_on_dichiarazione_stage_question'
    t.index ['dichiarazione_id'], name: 'index_declaration_answer_files_on_dichiarazione_id'
  end

  create_table 'declaration_templates', force: :cascade do |t|
    t.integer 'year', null: false
    t.jsonb 'invoices', default: {}, null: false
    t.jsonb 'contributions', default: {}, null: false
    t.jsonb 'quiz', default: {}, null: false
    t.jsonb 'f24_in_progress', default: {}, null: false
    t.jsonb 'income_statement', default: {}, null: false
    t.string 'default_active_stage', default: 'invoices'
    t.boolean 'active', default: true
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['active'], name: 'index_declaration_templates_on_active'
    t.index ['contributions'], name: 'index_declaration_templates_on_contributions', using: :gin
    t.index ['invoices'], name: 'index_declaration_templates_on_invoices', using: :gin
    t.index ['quiz'], name: 'index_declaration_templates_on_quiz', using: :gin
    t.index ['year'], name: 'index_declaration_templates_on_year'
  end

  create_table 'dichiaraziones', force: :cascade do |t|
    t.bigint 'anno'
    t.bigint 'user_id'
    t.boolean 'attivo', default: false
    t.text 'link_calendly'
    t.text 'appunti_videoconsulenza'
    t.boolean 'step_fatture_completato', default: false
    t.boolean 'step_doc_completato', default: false
    t.boolean 'step_quiz_completato', default: false
    t.boolean 'step_consulenza_prenotata', default: false
    t.boolean 'step_f24_caricati', default: false
    t.boolean 'step_percorso_completato', default: false
    t.boolean 'step_modello_redditi_caricato', default: false
    t.text 'quiz_conti_esteri'
    t.boolean 'quiz_immobili'
    t.boolean 'quiz_redditi_affitto'
    t.boolean 'quiz_altri_redditi'
    t.text 'quiz_2_1000'
    t.text 'quiz_5_1000'
    t.text 'quiz_8_1000'
    t.text 'quiz_coniugi'
    t.boolean 'quiz_residenza'
    t.boolean 'quiz_aiuti_stato'
    t.boolean 'quiz_rate'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.text 'quiz_libero'
    t.boolean 'step_enpam_completato', default: false
    t.boolean 'obbligo_modello_d', default: false
    t.boolean 'diritto_contrib_ridotta', default: false
    t.decimal 'importo_modello_d', default: '0.0'
    t.text 'scheda_enpam', default: 'chiuso'
    t.jsonb 'dati'
    t.text 'note', default: ''
    t.string 'responsabile', default: 'Personale'
    t.boolean 'facile', default: true
    t.boolean 'fatto', default: false
    t.boolean 'saldo_acconto_pagato'
    t.boolean 'secondo_acconto_pagato'
    t.text 'appunti_saldo_acconto', default: ''
    t.text 'appunti_secondo_acconto', default: ''
    t.integer 'template_id'
    t.jsonb 'answers_invoices', default: {}
    t.jsonb 'answers_contributions', default: {}
    t.jsonb 'answers_quiz', default: {}
    t.jsonb 'answers_f24_in_progress', default: {}
    t.jsonb 'answers_income_statement', default: {}
    t.string 'active_stage', default: 'invoices'
    t.index ['active_stage'], name: 'index_dichiaraziones_on_active_stage'
    t.index ['answers_contributions'], name: 'index_dichiaraziones_on_answers_contributions', using: :gin
    t.index ['answers_invoices'], name: 'index_dichiaraziones_on_answers_invoices', using: :gin
    t.index ['answers_quiz'], name: 'index_dichiaraziones_on_answers_quiz', using: :gin
    t.index ['template_id'], name: 'index_dichiaraziones_on_template_id'
    t.index ['user_id'], name: 'idx_38762_index_dichiaraziones_on_user_id'
  end

  create_table 'employees_physicians', force: :cascade do |t|
    t.bigint 'employee_id', null: false
    t.bigint 'physician_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['employee_id'], name: 'index_employees_physicians_on_employee_id'
    t.index ['physician_id'], name: 'index_employees_physicians_on_physician_id', unique: true
  end

  create_table 'esito_fatturas', force: :cascade do |t|
    t.bigint 'fattura_id'
    t.text 'esito'
    t.text 'codice'
    t.text 'errore'
    t.text 'suggerimento'
    t.text 'data_trasmissione'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.text 'descrizione'
    t.text 'data_messa_a_disposizione'
    t.index ['fattura_id'], name: 'idx_38683_index_esito_fatturas_on_fattura_id'
  end

  create_table 'f24s', force: :cascade do |t|
    t.bigint 'dichiarazione_id'
    t.bigint 'user_id'
    t.text 'uuid'
    t.decimal 'importo'
    t.datetime 'data_scadenza'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.datetime 'primo_download'
    t.string 'tipologia'
  end

  create_table 'fatturas', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'numero'
    t.datetime 'data_emissione'
    t.text 'formato'
    t.bigint 'cliente_id'
    t.float 'totale'
    t.bigint 'metdodo_di_pagamento_id'
    t.text 'nome_file'
    t.boolean 'incassata'
    t.datetime 'data_incasso'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.boolean 'trasmessa_a_sdi', default: false
    t.text 'errore_trasmissione_sdi'
    t.text 'data_trasmissione_sdi'
    t.text 'parametri_trasmissione_sdi'
    t.text 'file_xml_sdi'
    t.text 'nome_file_xml_sdi'
    t.text 'codice_sdi'
    t.text 'tipologia', default: 'fattura'
    t.text 'uuid_s3'
    t.text 'xml_non_firmato'
    t.boolean 'firmato', default: false
    t.boolean 'email_inviata', default: false
    t.boolean 'inviata_ts', default: false
    t.string 'sezionale'
    t.float 'rimborso', default: 0.0
    t.integer 'year'
    t.bigint 'payment_id'
    t.bigint 'physician_id'
    t.index ['codice_sdi'], name: 'idx_38664_index_fatturas_on_codice_sdi'
    t.index ['firmato'], name: 'idx_38664_index_fatturas_on_firmato'
    t.index ['payment_id'], name: 'index_fatturas_on_payment_id'
    t.index ['physician_id'], name: 'index_fatturas_on_physician_id'
    t.index ['user_id'], name: 'idx_38664_index_fatturas_on_user_id'
    t.index ['year'], name: 'index_fatturas_on_year'
  end

  create_table 'file_condivisos', force: :cascade do |t|
    t.bigint 'user_id'
    t.text 'public_uuid'
    t.text 'nome_file'
    t.text 'uuid_file'
    t.text 'nota'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.text 'role'
    t.string 'file_type', default: 'file_condiviso'
    t.bigint 'commercialista_id'
    t.bigint 'medico_id'
    t.string 'owner', default: 'medico'
    t.index ['commercialista_id'], name: 'index_file_condivisos_on_commercialista_id'
    t.index ['medico_id'], name: 'index_file_condivisos_on_medico_id'
    t.index ['public_uuid'], name: 'idx_38690_index_file_condivisos_on_public_uuid'
    t.index ['user_id'], name: 'idx_38690_index_file_condivisos_on_user_id'
  end

  create_table 'financial_advisors_employees', force: :cascade do |t|
    t.bigint 'financial_advisor_id', null: false
    t.bigint 'employee_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['employee_id'], name: 'index_financial_advisors_employees_on_employee_id'
    t.index %w[financial_advisor_id employee_id],
            name: 'index_financial_advisors_employees_on_advisor_and_employee', unique: true
    t.index ['financial_advisor_id'], name: 'index_financial_advisors_employees_on_financial_advisor_id'
  end

  create_table 'importo_commercialista', force: :cascade do |t|
    t.bigint 'commercialista_id', null: false
    t.datetime 'mese'
    t.integer 'utenti', default: 0
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['commercialista_id'], name: 'index_importo_commercialista_on_commercialista_id'
  end

  create_table 'impostazionis', force: :cascade do |t|
    t.boolean 'percorso_dichiarativo_aperto', default: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'leads', force: :cascade do |t|
    t.string 'email'
    t.string 'telefono'
    t.string 'nome'
    t.text 'messaggio'
    t.text 'nota'
    t.boolean 'ebook_letto'
    t.string 'canale_di_acquisizione'
    t.boolean 'chiamato', default: false
    t.bigint 'user_id'
    t.boolean 'cantina', default: true
    t.integer 'position'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'landing_di_provenienza'
    t.index ['user_id'], name: 'index_leads_on_user_id'
  end

  create_table 'medicos', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.string 'nome'
    t.string 'cognome'
    t.string 'cf'
    t.string 'pec'
    t.string 'telefono'
    t.string 'partita_iva'
    t.string 'data_di_nascita'
    t.string 'ordine'
    t.string 'indirizzo'
    t.string 'nazione', default: 'IT'
    t.string 'comune'
    t.string 'cap'
    t.string 'provincia'
    t.boolean 'watched_fiscomed_video', default: false
    t.integer 'anno_apertura_p_iva', default: 2022
    t.string 'codice_collega'
    t.integer 'colleghi_convinti', default: 0
    t.integer 'user_id_codice_collega'
    t.datetime 'data_apertura_p_iva'
    t.integer 'tentativo_pagamento', default: 0
    t.jsonb 'documenti', default: { 'documenti' => [] }
    t.boolean 'aliquota_ridotta'
    t.string 'ateco', default: ''
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'commercialista_id'
    t.text 'note_admin', default: ''
    t.text 'note_commercialista', default: ''
    t.datetime 'data_invio_pdf_riepilogativo'
    t.string 'contact_id'
    t.string 'mail_status'
    t.string 'mail_tags'
    t.string 'stripe_customer_id'
    t.jsonb 'storico', default: { 'risposte' => [] }
    t.string 'iscrizione_albo', default: [], array: true
    t.boolean 'errore_iscrizione_albo', default: false
    t.text 'descrizione_errore_iscrizione_albo'
    t.index ['codice_collega'], name: 'index_medicos_on_codice_collega'
    t.index ['commercialista_id'], name: 'index_medicos_on_commercialista_id'
    t.index ['user_id'], name: 'index_medicos_on_user_id'
  end

  create_table 'metodo_di_pagamentos', force: :cascade do |t|
    t.bigint 'user_id'
    t.text 'intestatario'
    t.text 'iban'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.boolean 'cancellato', default: false
    t.string 'alias', default: '', null: false
    t.index ['user_id'], name: 'idx_38656_index_metodo_di_pagamentos_on_user_id'
  end

  create_table 'modello_redditis', force: :cascade do |t|
    t.text 'uudi'
    t.bigint 'dichiarazione_id'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
  end

  create_table 'ocr_extraction_links', force: :cascade do |t|
    t.bigint 'ocr_extraction_id', null: false
    t.string 'extractable_type', null: false
    t.bigint 'extractable_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[extractable_type extractable_id], name: 'index_ocr_extraction_links_on_extractable'
    t.index ['ocr_extraction_id'], name: 'index_ocr_extraction_links_on_ocr_extraction_id'
  end

  create_table 'ocr_extractions', force: :cascade do |t|
    t.string 'type', null: false
    t.jsonb 'data', default: {}, null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['data'], name: 'index_ocr_extractions_on_data', using: :gin
    t.index ['type'], name: 'index_ocr_extractions_on_type'
  end

  create_table 'payment_attempts', force: :cascade do |t|
    t.text 'email'
    t.text 'password'
    t.text 'nome'
    t.text 'cognome'
    t.text 'indirizzo'
    t.text 'codicefiscale'
    t.text 'cap'
    t.text 'comune'
    t.text 'provincia'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.bigint 'user_id_codice_collega'
    t.index ['email'], name: 'idx_38723_index_payment_attempts_on_email', unique: true
  end

  create_table 'payments', force: :cascade do |t|
    t.string 'provider', default: 'stripe', null: false
    t.integer 'status', default: 0, null: false
    t.jsonb 'data', default: {}, null: false
    t.string 'customer', null: false
    t.string 'external_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'proformas', force: :cascade do |t|
    t.bigint 'user_id'
    t.date 'data_emissione'
    t.bigint 'cliente_id'
    t.text 'cliente_ragione_sociale'
    t.decimal 'totale'
    t.bigint 'metodo_di_pagamento_id'
    t.text 'nome_file'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.index ['user_id'], name: 'idx_38704_index_proformas_on_user_id'
  end

  create_table 'sezionale_blocchettos', force: :cascade do |t|
    t.bigint 'user_id'
    t.text 'cliente'
    t.bigint 'importo'
    t.bigint 'incassata_anno'
    t.text 'numero'
    t.bigint 'anno'
    t.text 'nome_originale_file'
    t.text 'uuid_file'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.datetime 'data_incasso'
    t.text 'tipologia', default: 'fattura'
    t.bigint 'trattenuta_enpam', default: 0
    t.boolean 'inviata_ts', default: false
    t.boolean 'controllato', default: false
    t.integer 'trattenuta_irpef', default: 0
    t.string 'partita_iva'
    t.string 'codice_fiscale'
    t.string 'appunti_verifica', default: ''
    t.index ['user_id'], name: 'idx_38729_index_sezionale_blocchettos_on_user_id'
  end

  create_table 'subscriptions', force: :cascade do |t|
    t.bigint 'medico_id'
    t.string 'stripe_subscription_id'
    t.string 'status'
    t.datetime 'start_date'
    t.datetime 'end_date'
    t.text 'note'
    t.boolean 'visible', default: true
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tag_blogs', force: :cascade do |t|
    t.text 'nome', default: ''
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
  end

  create_table 'tasses', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'anno'
    t.float 'albo'
    t.float 'quota_a'
    t.float 'quota_b'
    t.float 'impotsta_sostitutiva'
    t.float 'coefficiente_redditivita'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.float 'acconto', default: 0.0
    t.decimal 'saldo', default: '0.0'
    t.index ['user_id'], name: 'idx_38674_index_tasses_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.text 'email'
    t.text 'password'
    t.boolean 'email_confirmed', default: false
    t.text 'activation_email_token'
    t.text 'change_password_token'
    t.text 'uuid'
    t.text 'public_uuid'
    t.boolean 'active'
    t.datetime 'active_to'
    t.datetime 'created_at', precision: 6
    t.datetime 'updated_at', precision: 6
    t.text 'fisco_status'
    t.boolean 'moroso', default: false
    t.text 'moroso_dal'
    t.text 'fisco_nome'
    t.text 'fisco_cognome'
    t.text 'fisco_cf'
    t.text 'fisco_pec'
    t.text 'fisco_telefono'
    t.text 'fisco_partita_iva'
    t.text 'fisco_data_di_nascita'
    t.text 'fisco_ordine'
    t.text 'fisco_indirizzo'
    t.text 'fisco_nazione', default: 'IT'
    t.text 'fisco_comune'
    t.text 'fisco_cap'
    t.text 'fisco_provincia'
    t.text 'fisco_email_commercialista', default: 'francescorusso.fiscomed@gmail.com'
    t.boolean 'watched_fiscomed_video', default: false
    t.bigint 'anno_apertura_p_iva', default: 2022
    t.text 'codice_collega'
    t.bigint 'colleghi_convinti', default: 0
    t.bigint 'user_id_codice_collega'
    t.datetime 'data_apertura_p_iva'
    t.integer 'tentativo_pagamento', default: 0
    t.jsonb 'documenti', default: { 'documenti' => [] }
    t.boolean 'aliquota_ridotta'
    t.string 'ateco', default: ''
    t.string 'lettera_incarico', default: 'lettera_incarico_professionale.pdf'
    t.boolean 'commercialista_uomo', default: true
    t.string 'role', default: 'medico'
    t.index ['activation_email_token'], name: 'idx_38710_index_users_on_activation_email_token'
    t.index ['change_password_token'], name: 'idx_38710_index_users_on_change_password_token'
    t.index ['codice_collega'], name: 'idx_38710_index_users_on_codice_collega'
    t.index ['email'], name: 'idx_38710_index_users_on_email'
    t.index ['fisco_status'], name: 'idx_38710_index_users_on_fisco_status'
    t.index ['public_uuid'], name: 'idx_38710_index_users_on_public_uuid'
    t.index ['uuid'], name: 'idx_38710_index_users_on_uuid'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'ade_infos', 'medicos'
  add_foreign_key 'admins', 'users'
  add_foreign_key 'analisis', 'users'
  add_foreign_key 'commercialista', 'users'
  add_foreign_key 'declaration_answer_files', 'dichiaraziones'
  add_foreign_key 'dichiaraziones', 'declaration_templates', column: 'template_id'
  add_foreign_key 'employees_physicians', 'medicos', column: 'physician_id'
  add_foreign_key 'employees_physicians', 'users', column: 'employee_id'
  add_foreign_key 'fatturas', 'medicos', column: 'physician_id'
  add_foreign_key 'fatturas', 'payments'
  add_foreign_key 'file_condivisos', 'commercialista', column: 'commercialista_id'
  add_foreign_key 'file_condivisos', 'medicos'
  add_foreign_key 'financial_advisors_employees', 'commercialista', column: 'financial_advisor_id'
  add_foreign_key 'financial_advisors_employees', 'users', column: 'employee_id'
  add_foreign_key 'importo_commercialista', 'commercialista', column: 'commercialista_id'
  add_foreign_key 'leads', 'users'
  add_foreign_key 'medicos', 'users'
  add_foreign_key 'ocr_extraction_links', 'ocr_extractions'
end
