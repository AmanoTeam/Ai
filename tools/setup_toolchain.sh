#!/bin/bash

set -eu

declare -r AI_HOME='/tmp/ai-toolchain'

if [ -d "${AI_HOME}" ]; then
	PATH+=":${AI_HOME}/bin"
	export AI_HOME \
		PATH
	return 0
fi

declare -r AI_CROSS_TAG="$(jq --raw-output '.tag_name' <<< "$(curl --retry 10 --retry-delay 3 --silent --url 'https://api.github.com/repos/AmanoTeam/Ai/releases/latest')")"
declare -r AI_CROSS_TARBALL='/tmp/ai.tar.xz'
declare -r AI_CROSS_URL="https://github.com/AmanoTeam/Ai/releases/download/${AI_CROSS_TAG}/x86_64-unknown-linux-gnu.tar.xz"

curl --connect-timeout '10' --retry '15' --retry-all-errors --fail --silent --location --url "${AI_CROSS_URL}" --output "${AI_CROSS_TARBALL}"
tar --directory="$(dirname "${AI_CROSS_TARBALL}")" --extract --file="${AI_CROSS_TARBALL}"

rm "${AI_CROSS_TARBALL}"

mv '/tmp/ai' "${AI_HOME}"

PATH+=":${AI_HOME}/bin"

export AI_HOME \
	PATH
