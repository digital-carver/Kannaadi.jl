using Kannaadi
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@test எழுத்துவகை_பிரி('ஆ') == :உயிர்
@test எழுத்துவகை_பிரி('ம') == :உயிர்மெய்
@test எழுத்துவகை_பிரி("மை") == :உயிர்மெய்
@test எழுத்துவகை_பிரி("ப்") == :மெய்
@test எழுத்துவகை_பிரி('ௐ') == :எழுத்தல்ல
@test_throws ArgumentError எழுத்துவகை_பிரி('x')
@test_throws ArgumentError எழுத்துவகை_பிரி("blah")
@test_throws ArgumentError எழுத்துவகை_பிரி("நிரை")

@test மாத்திரை_அளவெடு('ஆ') == 2
@test மாத்திரை_அளவெடு('ம') == 1
@test மாத்திரை_அளவெடு("மை") == 2
@test மாத்திரை_அளவெடு("ப்") == 0
@test_throws ArgumentError மாத்திரை_அளவெடு('ௐ')
@test_throws ArgumentError மாத்திரை_அளவெடு('x')
@test_throws ArgumentError மாத்திரை_அளவெடு("blah")
@test_throws ArgumentError மாத்திரை_அளவெடு("நிரை")

@test துப்புரவு_செய்("தொகுப்பு (Package)") == "தொகுப்பு "
@test துப்புரவு_செய்("தமிழ் and English (2) உண்டு") == "தமிழ்    உண்டு"

@test தமிழுரையா("வணக்கம்") == true
@test தமிழுரையா("வணக்கம் தமிழகம்") == false
@test தமிழுரையா("vanakkam") == false
