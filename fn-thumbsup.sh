
#SAMPLE
#make_album stylized gal2 "JG AI Prod" "Copyright Guillaume Descoteaux-Isabelle, (2021) - David B.G. (n.d.)" "Experimentation of JG AI Style on David's work"

make_album()
{

    indir="$1"
    outdir="$2"
    title="$3"
    footer="$4"
    toplevelsitename="$5"
    homealbumname="$6"

    thumbsup --input $1 --output $2 \
      --thumb-size 140 \
      --small-size 380 \
      --large-size 1536 \
      --photo-quality 97 \
      --theme flow \
      --title "$title" \ 
      --footer "$footer" \
      --home-album-name  "$toplevelsitename" \
      --home-album-name "$homealbumname" \
      --cleanup 

}

#FUTUR
  #--watermark           Path to a transparent PNG to be overlaid on all images  [string]
  #--theme                 Name of a built-in gallery theme  [choices: "classic", "cards", "mosaic", "flow"] [default: "classic"]
#--theme-style           Path to a custom LESS/CSS file for additional styles  [string]
# --include-keywords

  #--seo-location 
  #--google-analytics      Code for Google Analytics tracking