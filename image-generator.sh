#!/usr/bin/env bash
set -e

# ./generator.sh https://github.com/jguddas/my-activity-dashboard
# ./generator.sh https://github.com/jguddas/sankey-playground
# ./generator.sh https://github.com/jguddas/next-ticker
# ./generator.sh https://github.com/jguddas/my-route-planner
# ./generator.sh https://github.com/jguddas/quicktype-ts-blaze
# ./generator.sh https://github.com/jguddas/quicktype-superstruct
# ./generator.sh https://github.com/jguddas/drawn-hannover
# ./generator.sh https://github.com/jguddas/menu-app

url=$1
page=$(curl -s "$url")
title=$(basename "$url")
description=$(grep '<title>' <<< "$page" | grep ':' | sed 's|.*: ||;s|</title>||')
t="$description ";t=${t:0:52};t=${t% *};t=${#t}
description1=$(cut -c-"$t" <<< "$description" || echo '')
description2=$(cut -c$((t + 1))- <<< "$description" || echo '')
languageelement=$(grep 'aria-label.*Progress-item' <<< "$page" | head -n1)
language=$(sed 's|.*aria-label="||;s| .*||' <<< "$languageelement")
languagecolor=$(sed 's|.*background-color:||;s| .*||' <<< "$languageelement")

export url
export title
export description
export description1
export description2
export language
export languagecolor

# shellcheck disable=SC2016
template='<svg xmlns="http://www.w3.org/2000/svg" version="1.2" viewBox="0 0 454 139">
  <g fill="none" fill-rule="evenodd" stroke-linecap="square" stroke-linejoin="bevel" transform="translate(6.5 4.8)">
    <path stroke="none" d="M0 0h440v130H0z"/>
    <rect width="441" height="129" stroke="$bordercolor" rx="6" ry="6"/>
    <path fill="$textcolor" stroke="none" d="M22 32.3h-1.3V31H22v1.3m0-3.8h-1.3v1.3H22v-1.3m0-2.5h-1.3v1.3H22V26m0-2.5h-1.3v1.3H22v-1.3m10-1.3v15c0 .7-.6 1.3-1.3 1.3h-6.2V41l-1.9-1.9-1.9 1.9v-2.5h-2.4c-.7 0-1.3-.6-1.3-1.3v-15c0-.6.6-1.2 1.3-1.2h12.4c.7 0 1.3.6 1.3 1.3m-1.3 12.4H18.4v2.5h2.4V36h3.8v1.3h6.3v-2.5m0-12.5H19.4v11.2h11.3V22.2"/>
    <a fill="$titlecolor">
      <text x="41" y="33" stroke="none" font-family="sans-serif" font-size="16" font-weight="630">$title</text>
    </a>
    <text x="17" y="65" fill="$textcolor" stroke="none" font-family="sans-serif" font-size="14" font-weight="400">
      <tspan x="17" y="65">$description1</tspan>
      <tspan x="17" y="82.5">$description2</tspan>
    </text>
    <text x="33" y="112" fill="$textcolor" stroke="none" font-family="sans-serif" font-size="12" font-weight="400">$language</text>
    <circle cx="23" cy="107" r="7" fill="$languagecolor" stroke="$textcolor"/>
  </g>
</svg>'

export bordercolor='#444c56'
export textcolor='#8b949e'
export titlecolor='#58a6ff'
envsubst <<< "$template" > "images/$title"-dark.svg

export bordercolor='#d0d7de'
export textcolor='#57606a'
export titlecolor='#0969da'
envsubst <<< "$template" > "images/$title"-light.svg

if [[ -n "$description" ]]; then
  export alt="$title: $description"
else
  export alt="$title"
fi
# shellcheck disable=SC2016
envsubst <<< '<a href="$url#gh-light-mode-only">
  <img
    src="images/$title-light.svg"
    alt="$alt"
    width="400"
  />
</a>
<a href="$url#gh-dark-mode-only">
  <img
    src="images/$title-dark.svg"
    alt="$alt"
    width="400"
  />
</a>'
