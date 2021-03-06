
export எழுத்துவகை_பிரி, மாத்திரை_அளவெடு, துப்புரவு_செய், தமிழுரையா
export உயிரெழுத்துக்கள், புள்ளி, ஆய்தம்

if VERSION > v"0.7.0" #FIXME: should use DEV build that made the change
    using Unicode: graphemes
end

const உயிரெழுத்துக்கள் = ["அ", "ஆ", "இ", "ஈ", "உ", "ஊ", "எ", "ஏ", "ஐ", "ஒ", "ஓ", "ஔ"]
const வல்லினங்கள் = ["க", "ச", "ட", "த", "ப", "ற"]
const மெல்லினங்கள் = ["ங",  "ஞ", "ண", "ந", "ம", "ன"]
const இடையினங்கள் = ["ய", "ர", "ல", "வ", "ழ", "ள"]
const அகரங்கள் = [வல்லினங்கள்;  மெல்லினங்கள்;  இடையினங்கள்]
const உயிர்ப்பகுதிகள் = ['ா', 'ி', 'ீ', 'ு', 'ூ', 'ெ', 'ே', 'ை', 'ொ', 'ோ', 'ௌ']
const புள்ளி = '்'
const ஆய்தம் = "ஃ"
#TODO: add grantham letters

எழுத்துவகை_பிரி(l::Char) = எழுத்துவகை_பிரி(string(l))
function எழுத்துவகை_பிரி(எழுத்து::AbstractString) #FIXME: needs better return type idea
    எழுத்து == ஆய்தம் && return :ஆய்தம்
    எழுத்து in உயிரெழுத்துக்கள் && return :உயிர்
    எழுத்து in அகரங்கள் && return :உயிர்மெய்

    ஓரெழுத்து_உறுதிசெய்(எழுத்து)
    தமிழுரையா(எழுத்து) || throw(ArgumentError("கொடுத்த குறி $எழுத்து தமிழ் எழுத்தல்ல (E:ARG_NT)"))

    if length(எழுத்து) == 1
        return :எழுத்தல்ல #தமிழ் எண்கள், நாட்காட்டிக் குறிப்புகள், முதலியவை (இப்போதைக்கு கிரந்தங்களும்)
    end

    எழுத்துப்பகுதி = எழுத்து[nextind(எழுத்து, 1)]
    எழுத்துப்பகுதி == புள்ளி && return :மெய்
    எழுத்துப்பகுதி in உயிர்ப்பகுதிகள் && return :உயிர்மெய்
end
const classify_letter = எழுத்துவகை_பிரி

மாத்திரை_அளவெடு(l::Char) = மாத்திரை_அளவெடு(string(l))
function மாத்திரை_அளவெடு(எழுத்து::AbstractString)
    எழுத்துவகை = எழுத்துவகை_பிரி(எழுத்து)

    #could give maathirai values to ௹, ௐ, etc?
    எழுத்துவகை == :எழுத்தல்ல && throw(ArgumentError("கொடுத்த குறி $எழுத்து மாத்திரை கொண்டதல்ல (E:ARG_NL)"))

    எழுத்துவகை in (:மெய், :ஆய்தம்) && return 0

    if எழுத்துவகை == :உயிர்
        if எழுத்து in உயிரெழுத்துக்கள்[[2, 4, 6, 8, 9, 11, 12]]
            return 2
        else
            return 1
        end
    end

    #அகர உயிர்மெய்கள் ஒரு codepoint நீளம் கொண்டவை
    length(எழுத்து) == 1 && return 1

    உயிர்ப்பகுதி = எழுத்து[nextind(எழுத்து, 1)]
    if உயிர்ப்பகுதி in உயிர்ப்பகுதிகள்[[1, 3, 5, 7, 8, 10, 11]]
        return 2
    else
        return 1
    end
end
const get_vowel_length = மாத்திரை_அளவெடு

ஓரெழுத்து_உறுதிசெய்(l::Char) = true
function ஓரெழுத்து_உறுதிசெய்(எழுத்து::AbstractString)
    if length(graphemes(எழுத்து)) > 1
        throw(ArgumentError("ஒரு எழுத்தை மட்டும் கொடுக்கவும் (கொடுத்தது: $எழுத்து) (E:ARG_GM)"))
    end
    true
end
const assert_single_grapheme = ஓரெழுத்து_உறுதிசெய்

function தமிழுரையா(எழுத்து::AbstractString)
    #TODO: add options to allow space, etc.
    ismatch(r"^\p{Tamil}+$", எழுத்து)
end
const is_tamil_text = தமிழுரையா

"""
துப்புரவு_செய்(உரை) -> தமிழுரை
தமிழ் எழுத்துக்கள், வெற்றிடங்கள் தவிர அனைத்தும் நீக்கு
"""
function துப்புரவு_செய்(உரை::AbstractString, எச்சரி=false)
    #TODO: add options to leave punctutations, digits, etc. in
    if VERSION > v"0.7.0" #FIXME: should use DEV build that made the change
        தமிழுரை = replace(உரை, r"[^\p{Tamil}\s]" => "")
    else
        தமிழுரை = replace(உரை, r"[^\p{Tamil}\s]", "")
    end
    நீக்கப்பட்டன = length(உரை) - length(தமிழுரை)
    if எச்சரி && (நீக்கப்பட்டன > 0)
        warn("தமிழல்லாத $(நீக்கப்பட்டன) எழுத்துக்கள் உரையிலிருந்து நீக்கப்பட்டன")
    end
    return தமிழுரை
end
const cleanup = துப்புரவு_செய்
