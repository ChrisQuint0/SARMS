import os
from lxml import etree

def resolve_and_validate():
    xml_path = "sarms.xml"
    xsd_path = "sarms.xsd"
    dtd_path = "sarms.dtd"
    merged_path = "sarms_merged.xml"

    print("--- STEP 1: Resolving XIncludes in sarms.xml ---")
    if not os.path.exists(xml_path):
        print(f"Error: {xml_path} not found.")
        return

    # Set up parser with XInclude support enabled
    parser = etree.XMLParser(load_dtd=True, resolve_entities=True)
    try:
        tree = etree.parse(xml_path, parser=parser)
        # Resolve all XIncludes
        tree.xinclude()
        print("XInclude resolution completed successfully!")
        
        # Remove xml:base attributes injected by XInclude processor
        # xml:base namespace is http://www.w3.org/XML/1998/namespace
        xml_base_ns = "{http://www.w3.org/XML/1998/namespace}base"
        for elem in tree.iter():
            if xml_base_ns in elem.attrib:
                del elem.attrib[xml_base_ns]
        print("Removed xml:base attributes injected during XInclude resolution.")
    except Exception as e:
        print(f"Error parsing/resolving XInclude: {e}")
        return

    # Save the merged/flattened XML file
    try:
        tree.write(merged_path, pretty_print=True, xml_declaration=True, encoding="utf-8")
        print(f"Merged/Flattened XML saved to: {merged_path}")
    except Exception as e:
        print(f"Error saving merged XML: {e}")
        return

    print("\n--- STEP 2: Validating against sarms.xsd ---")
    if not os.path.exists(xsd_path):
        print(f"Error: {xsd_path} not found.")
    else:
        try:
            xsd_doc = etree.parse(xsd_path)
            xmlschema = etree.XMLSchema(xsd_doc)
            
            # Load the merged XML for XSD validation
            merged_tree = etree.parse(merged_path)
            
            if xmlschema.validate(merged_tree):
                print("SUCCESS: sarms_merged.xml is VALID against sarms.xsd!")
            else:
                print("FAILURE: sarms_merged.xml is INVALID against sarms.xsd.")
                print(f"Total XSD Errors: {len(xmlschema.error_log)}")
                print("First 10 Errors:")
                for i, error in enumerate(xmlschema.error_log):
                    if i >= 10:
                        break
                    print(f"  Line {error.line}: {error.message}")
        except Exception as e:
            print(f"Error during XSD validation: {e}")

    print("\n--- STEP 3: Validating against sarms.dtd ---")
    if not os.path.exists(dtd_path):
        print(f"Error: {dtd_path} not found.")
    else:
        try:
            # DTD validation can be done by parsing the file with DTD validation enabled
            # or by loading the DTD explicitly and validating.
            with open(dtd_path, 'rb') as f:
                dtd = etree.DTD(f)
            
            merged_tree = etree.parse(merged_path)
            if dtd.validate(merged_tree):
                print("SUCCESS: sarms_merged.xml is VALID against sarms.dtd!")
            else:
                print("FAILURE: sarms_merged.xml is INVALID against sarms.dtd.")
                print(f"Total DTD Errors: {len(dtd.error_log)}")
                print("First 10 Errors:")
                for i, error in enumerate(dtd.error_log):
                    if i >= 10:
                        break
                    print(f"  Line {error.line}: {error.message}")
        except Exception as e:
            print(f"Error during DTD validation: {e}")

if __name__ == "__main__":
    resolve_and_validate()
