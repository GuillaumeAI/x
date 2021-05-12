


make_album()
{

    indir="$1"
    outdir="$2"
    title="$3"
    footer="$4"
    toplevelsitename="$5"


    thumbsup --input $1 --output $2 \
      --thumb-size 140 \
      --small-size 380 \
      --large-size 1536 \
      --photo-quality 97 \
      --theme flow \
      --title "$title" \ 
      --footer "$footer" \
      --home-album-name  "$toplevelsitename" \
      --cleanup 

}

#FUTUR
  #--watermark           Path to a transparent PNG to be overlaid on all images  [string]
  #--theme                 Name of a built-in gallery theme  [choices: "classic", "cards", "mosaic", "flow"] [default: "classic"]
#--theme-style           Path to a custom LESS/CSS file for additional styles  [string]
# --include-keywords

  #--seo-location 
  #--google-analytics      Code for Google Analytics tracking