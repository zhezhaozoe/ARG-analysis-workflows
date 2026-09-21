#!/bin/bash

# Identify ARG and MGE genes located on the same contig and within 5 kb.
# Usage:
#   bash find_5k_mges_args_from_faa.sh mges.faa args.faa
# Input:
#   mges.faa  Prodigal-format protein FASTA containing MGE genes
#   args.faa  Prodigal-format protein FASTA containing ARGs
# Output:
#   mges_args_5k_results.tsv

if [ "$#" -ne 2 ]; then
    echo "Usage: bash $0 mges.faa args.faa"
    exit 1
fi

mges_faa="$1"
args_faa="$2"

if [[ ! -f "$mges_faa" || ! -r "$mges_faa" ]]; then
    echo "ERROR: MGE FASTA file not found or not readable: $mges_faa" >&2
    exit 1
fi

if [[ ! -f "$args_faa" || ! -r "$args_faa" ]]; then
    echo "ERROR: ARG FASTA file not found or not readable: $args_faa" >&2
    exit 1
fi

{
    printf 'Contig\tMGE_ID\tMGE_Start\tMGE_End\tMGE_Strand\tARG_ID\tARG_Start\tARG_End\tARG_Strand\tDistance\n'

    awk '
BEGIN {
    OFS="\t"
}

/^>/ {
    # Full Prodigal protein ID.
    full_id = substr($1, 2)

    # Remove the terminal ORF number (_N) to recover the contig ID.
    contig = full_id
    sub(/_[0-9]+$/, "", contig)

    # Prodigal protein FASTA header format:
    # >ID # start # end # strand # ...
    start = $3
    end = $5
    strand = $7

    if (start > end) {
        tmp = start
        start = end
        end = tmp
    }

    if (FILENAME == ARGV[1]) {
        i = ++mcount[contig]
        key = contig SUBSEP i
        m_id[key] = full_id
        m_start[key] = start
        m_end[key] = end
        m_strand[key] = strand
    } else {
        i = ++acount[contig]
        key = contig SUBSEP i
        a_id[key] = full_id
        a_start[key] = start
        a_end[key] = end
        a_strand[key] = strand
    }
}

END {
    for (c in mcount) {
        if (!(c in acount))
            continue
        for (i = 1; i <= mcount[c]; i++) {
            mk = c SUBSEP i
            for (j = 1; j <= acount[c]; j++) {
                ak = c SUBSEP j
                if (m_end[mk] < a_start[ak])
                    dist = a_start[ak] - m_end[mk]
                else if (a_end[ak] < m_start[mk])
                    dist = m_start[mk] - a_end[ak]
                else
                    dist = 0
                if (dist <= 5000) {
                    print c, \
                          m_id[mk], m_start[mk], m_end[mk], m_strand[mk], \
                          a_id[ak], a_start[ak], a_end[ak], a_strand[ak], \
                          dist
                }
            }
        }
    }
}
' "$mges_faa" "$args_faa" |
    LC_ALL=C sort -t $'\t' -k1,1 -k2,2 -k6,6

} > mges_args_5k_results.tsv

echo "Analysis completed. Results saved to: mges_args_5k_results.tsv"
