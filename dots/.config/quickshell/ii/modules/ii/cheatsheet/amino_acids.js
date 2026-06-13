var aminoAcids = [
    // Nonpolar, aliphatic
    [
        { code1: "G", code3: "Gly", name: "Glycine",       sideChain: "-H",           category: "nonpolar" },
        { code1: "A", code3: "Ala", name: "Alanine",       sideChain: "-CH₃",         category: "nonpolar" },
        { code1: "V", code3: "Val", name: "Valine",        sideChain: "-CH(CH₃)₂",    category: "nonpolar" },
        { code1: "L", code3: "Leu", name: "Leucine",       sideChain: "-CH₂CH(CH₃)₂", category: "nonpolar" },
        { code1: "I", code3: "Ile", name: "Isoleucine",    sideChain: "-CH(CH₃)C₂H₅", category: "nonpolar" },
        { code1: "P", code3: "Pro", name: "Proline",       sideChain: "-(CH₂)₃- (ring)", category: "nonpolar" },
        { code1: "M", code3: "Met", name: "Methionine",    sideChain: "-CH₂CH₂SCH₃",  category: "nonpolar" },
    ],
    // Aromatic
    [
        { code1: "F", code3: "Phe", name: "Phenylalanine", sideChain: "-CH₂C₆H₅",     category: "aromatic" },
        { code1: "Y", code3: "Tyr", name: "Tyrosine",      sideChain: "-CH₂C₆H₄OH",  category: "aromatic" },
        { code1: "W", code3: "Trp", name: "Tryptophan",    sideChain: "-CH₂C₈H₆N",   category: "aromatic" },
    ],
    // Polar, uncharged
    [
        { code1: "S", code3: "Ser", name: "Serine",        sideChain: "-CH₂OH",       category: "polar" },
        { code1: "T", code3: "Thr", name: "Threonine",     sideChain: "-CH(OH)CH₃",   category: "polar" },
        { code1: "C", code3: "Cys", name: "Cysteine",      sideChain: "-CH₂SH",       category: "polar" },
        { code1: "N", code3: "Asn", name: "Asparagine",    sideChain: "-CH₂CONH₂",    category: "polar" },
        { code1: "Q", code3: "Gln", name: "Glutamine",     sideChain: "-CH₂CH₂CONH₂", category: "polar" },
    ],
    // Positively charged
    [
        { code1: "K", code3: "Lys", name: "Lysine",        sideChain: "-(CH₂)₄NH₃⁺",  category: "positive" },
        { code1: "R", code3: "Arg", name: "Arginine",      sideChain: "-(CH₂)₃NHC(=NH)NH₂", category: "positive" },
        { code1: "H", code3: "His", name: "Histidine",     sideChain: "-CH₂C₃H₃N₂",  category: "positive" },
    ],
    // Negatively charged
    [
        { code1: "D", code3: "Asp", name: "Aspartic acid", sideChain: "-CH₂COO⁻",     category: "negative" },
        { code1: "E", code3: "Glu", name: "Glutamic acid", sideChain: "-CH₂CH₂COO⁻",  category: "negative" },
    ],
]

var categoryNames = {
    "nonpolar": "Nonpolar, Aliphatic",
    "aromatic": "Aromatic",
    "polar": "Polar, Uncharged",
    "positive": "Positively Charged",
    "negative": "Negatively Charged",
}

var categoryColors = {
    "nonpolar": "#ffcc00",
    "aromatic": "#ff9900",
    "polar": "#00cc66",
    "positive": "#0066ff",
    "negative": "#cc0000",
}
