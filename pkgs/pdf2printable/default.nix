{
  writeShellScriptBin,
  pdftk,
  texlivePackages,
}:

let
  _pdfjam = "${texlivePackages.pdfjam}/bin/pdfjam";
  _pdftk = "${pdftk}/bin/pdftk";
in
writeShellScriptBin "pdf2printable" ''
  if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.pdf output.pdf"
    exit 1
  fi

  input_pdf="$1"
  output_pdf="$2"

  even_pdf="even.pdf"
  even_rotated_pdf="even_rotated.pdf"
  landscape_pdf="landscape.pdf"
  odd_pdf="odd.pdf"

  # Convert the PDF to landscape
  ${_pdfjam} --landscape --nup 2x1 "$input_pdf" -o "$landscape_pdf"

  # Split the PDF into odd and even pages
  ${_pdftk} "$landscape_pdf" cat odd output "$odd_pdf"
  ${_pdftk} "$landscape_pdf" cat even output "$even_pdf"

  # Rotate the even pages by 180 degrees
  ${_pdfjam} --landscape "$even_pdf" --angle 180 --outfile "$even_rotated_pdf"

  # Merge the odd and rotated even pages
  ${_pdftk} A="$odd_pdf" B="$even_rotated_pdf" shuffle A B output "$output_pdf"

  rm "$odd_pdf" "$even_pdf" "$landscape_pdf" "$even_rotated_pdf"
''
