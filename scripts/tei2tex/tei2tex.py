#!/usr/bin/env python3
"""
Script de conversion d'un document TEI XML en LaTeX :
- Ne conserve que le contenu des balises <reg>
- Ignore <orig> et <fw>
- Gère les sauts de page TEI (<pb> → \newpage)
- Conserve les italiques et la casse existante
- Génère un index des personnes à la fin, à partir de <listPerson> avec renvoi aux pages
Usage : python tei2tex.py input.xml output.tex
"""

import sys
from lxml import etree

# Namespace TEI
NS = {'tei': 'http://www.tei-c.org/ns/1.0'}


def parse_persons(root):
    """Retourne un dict id_person -> nom_affiché"""
    persons = {}
    for person in root.findall('.//tei:listPerson/tei:person', namespaces=NS):
        pid = person.get('{http://www.w3.org/XML/1998/namespace}id')
        name_el = person.find('tei:persName', namespaces=NS)
        if pid and name_el is not None:
            persons[pid] = ''.join(name_el.itertext()).strip()
    return persons


def write_index(out, persons, person_pages):
    """Écrit l'index des personnes à la fin du document LaTeX"""
    # Saut de page avant l'index
    out.write('\\newpage\n')
    out.write('\\section*{Index des personnes}\n')
    out.write('\\begin{itemize}\n')
    for pid, name in persons.items():
        pages = sorted(person_pages.get(pid, []))
        if pages:
            page_list = ', '.join(str(p) for p in pages)
            out.write(f'  \\item {name}: {page_list}\n')
    out.write('\\end{itemize}\n')


def process_node(node, current_page, person_pages):
    """Retourne le texte LaTeX généré pour ce nœud, et met à jour person_pages."""
    ln = etree.QName(node).localname
    # Saut de page TEI
    if ln == 'pb':
        current_page += 1
        return '\\newpage\n', current_page
    # Ignorer <orig>, <fw>, <lb>
    if ln in ('orig', 'fw', 'lb'):
        return '', current_page
    # <choice> → on traite <reg>
    if ln == 'choice':
        reg = node.find('tei:reg', namespaces=NS)
        if reg is not None:
            return process_node(reg, current_page, person_pages)
        return '', current_page
    # Contenu de <reg>
    if ln == 'reg':
        text = node.text or ''
        for child in node:
            fragment, current_page = process_node(child, current_page, person_pages)
            text += fragment
        text += node.tail or ''
        return text, current_page
    # <hi rend="italic"> → \textit
    if ln == 'hi':
        content = node.text or ''
        for child in node:
            frag, current_page = process_node(child, current_page, person_pages)
            content += frag
        content += node.tail or ''
        rend = node.get('rend', '')
        if 'italic' in rend:
            return f'\\textit{{{content}}}', current_page
        return content, current_page
    # <persName> → enregistrer page et afficher nom
    if ln == 'persName':
        ref = node.get('ref', '').lstrip('#')
        name = ''.join(node.itertext())
        person_pages.setdefault(ref, set()).add(current_page)
        return name, current_page
    # Vers (<l>) → fin de ligne
    if ln == 'l':
        text = ''
        for child in node:
            frag, current_page = process_node(child, current_page, person_pages)
            text += frag
        return text + ' \\\\n', current_page
    # Conteneurs (p, div, etc.) → récursif
    text = ''
    for child in node:
        frag, current_page = process_node(child, current_page, person_pages)
        text += frag
    if ln in ('p', 'ab', 'div', 'head', 'lg'):
        text += '\n'
    return text, current_page


def main():
    if len(sys.argv) != 3:
        sys.exit('Usage: python tei_to_tex_reg.py input.xml output.tex')
    inp, outp = sys.argv[1], sys.argv[2]

    tree = etree.parse(inp)
    root = tree.getroot()

    persons = parse_persons(root)
    person_pages = {}

    body = root.find('.//tei:body', namespaces=NS)
    current_page = 1

    with open(outp, 'w', encoding='utf-8') as out:
        out.write('\\documentclass{article}\n')
        out.write('\\usepackage[utf8]{inputenc}\n')
        out.write('\\usepackage[T1]{fontenc}\n')
        out.write('\\usepackage[french]{babel}\n')
        out.write('\\usepackage{hyperref}\n')
        out.write('\\begin{document}\n')

        if body is not None:
            for node in body:
                frag, current_page = process_node(node, current_page, person_pages)
                out.write(frag)
        else:
            out.write('% Aucun <body> trouvé\n')

        write_index(out, persons, person_pages)
        out.write('\\end{document}\n')

if __name__ == '__main__':
    main()
