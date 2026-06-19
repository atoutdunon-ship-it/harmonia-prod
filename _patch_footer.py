#!/usr/bin/env python3
import os

BASE = os.path.dirname(os.path.abspath(__file__))

SHARED_PATCHES = [
    (
        '<span style="font-family:Arial,sans-serif;font-size:10px;letter-spacing:4px;text-transform:uppercase;color:rgba(255,255,255,0.35);">',
        '<span style="font-family:Arial,sans-serif;font-size:10px;letter-spacing:4px;text-transform:uppercase;color:rgba(255,255,255,0.35);" data-editable-key="footer_tagline" data-i18n="footer_tagline">',
    ),
    (
        '>Sede — Mindelo</div>',
        ' data-editable-key="footer_sede_label" data-i18n="footer_sede_label">Sede — Mindelo</div>',
    ),
    (
        '>Escritório — Praia</div>',
        ' data-editable-key="footer_office_label" data-i18n="footer_office_label">Escritório — Praia</div>',
    ),
    (
        '>Contacto</div>',
        ' data-editable-key="footer_contact_label" data-i18n="footer_contact_label">Contacto</div>',
    ),
    (
        'Ribeira de Julião, Mindelo<br>',
        'Ribeira de Julião, Mindelo<br> data-editable-KEY-sede',
    ),
]

HOME_PATCHES = [
    (
        '<span class="hf-name">Harmonia LDA</span>',
        '<span class="hf-name" data-editable-key="footer_hf_name">Harmonia LDA</span>',
    ),
    (
        '<span class="hf-tag">Editora discográfica de Cabo Verde &nbsp;·&nbsp; desde 1998</span>',
        '<span class="hf-tag" data-editable-key="footer_hf_tag" data-i18n="footer_hf_tag">Editora discográfica de Cabo Verde &nbsp;·&nbsp; desde 1998</span>',
    ),
    (
        '<div class="home-footer-row3">© 2025 Harmonia LDA — Todos os direitos reservados</div>',
        '<div class="home-footer-row3" data-editable-key="footer_copy" data-i18n="footer_copy">© 2025 Harmonia LDA — Todos os direitos reservados</div>',
    ),
]

print("TEST OK")
