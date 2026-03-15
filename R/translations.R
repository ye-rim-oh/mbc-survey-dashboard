# R/translations.R

# ── Question translations ────────────────────────────────────────────────────
question_en <- c(
  "가족보다 개인의 직업 성공이 더 중요하다"                       = "Career success matters more than family",
  "결혼은 개인의 선택이다"                                         = "Marriage is not an obligation — it is a personal choice",
  "극단주의 제압할 강력한 지도자가 필요하다"                       = "We need a strong leader to suppress the extremism that is ruining our country",
  "기후위기 극복을 위한 강한 규제가 필요하다"                      = "Strong regulations are needed to address climate change",
  "나와 같은 계층은 충분히 보상을 받고 있다"                       = "People in my social class are fairly compensated",
  "나와 같은 세대는 충분히 보상을 받고 있다"                       = "My generation is fairly compensated",
  "남녀 임금 격차에는 타당한 이유가 있다"                          = "The gender wage gap has legitimate reasons",
  "남녀 임금 격차에는 타당한 이유가 있다."                         = "The gender wage gap has legitimate reasons",
  "노력하는 만큼 소득에 차이가 나야 한다"                          = "Income differences should reflect effort",
  "다음 세대에 살기 좋은 세상을 물려줘야 한다"                     = "We must leave a better world for the next generation",
  "명절에 제사 대신 해외여행은 비난받을 일이 아니다"               = "Going abroad on holiday breaks without holding memorial rites is not something to be criticized",
  "모두가 동등한 대우를 받는지 따지는 것은 중요하다"               = "Ensuring everyone receives equal treatment is important",
  "모든 사람은 동일한 삶의 지원을 받아야 한다"                     = "Everyone should receive the same level of life support",
  "모든 사람이 동일한 돈을 벌면 세상은 더 나아진다"               = "The world would be better if everyone earned the same",
  "모든 사람이 평등하게 대우 받는 것이 중요하다"                   = "Equal treatment for all people is important",
  "법 제정의 첫 원칙은 공평한 대우이다"                            = "Fair treatment should be the first principle of legislation",
  "부는 노력보다 운에 따라 결정된다"                               = "Wealth is determined more by luck than by effort",
  "부유해지는 것이 삶의 가장 중요한 목표다"                        = "Becoming wealthy is the most important goal in life",
  "부정행위자 처벌시 기분이 좋다"                                  = "It feels good when wrongdoers are caught and punished",
  "사회 제도를 허물고 다시 시작해야 한다"                          = "Since we cannot fix social institutions, they must be torn down and rebuilt from scratch",
  "사회가 완전히 무너져야 한다고 생각한다"                         = "I think society needs to completely collapse",
  "사회적 약자 보호 노력이 과하다"                                 = "Efforts to protect the vulnerable have gone too far",
  "성공하려면 타인을 눌러야 할 때도 있다"                          = "Success sometimes requires pushing others down",
  "세상에는 상대적으로 남보다 더 우월한 사람들이 있다"             = "Some people are inherently superior to others",
  "아이를 갖는 것은 사회적 의무다"                                 = "Having children is a social obligation",
  "약자 보호를 주장하는 사람들의 도덕적 우월감이 불편하다"         = "I feel uncomfortable with the moral superiority of those who advocate for minorities and the vulnerable",
  "약자나 취약한 위치에 있는 사람을 신경쓰는 것은 중요하다"        = "Caring for the weak and vulnerable is important",
  "약자를 공정하게 대우하는 것이 중요하다"                         = "Treating the vulnerable fairly is important",
  "어머니가 일하면 아이들이 어려움을 겪는다"                       = "Children suffer when mothers work",
  "여성은 가정과 아이들을 우선시해야 한다"                         = "Work is fine, but women should prioritize family and children",
  "연민과 동정은 중요한 덕목이다"                                  = "Compassion and sympathy are important virtues",
  "외국 자연재해에 짜릿함을 느낀다"                                = "I feel a thrill at natural disasters in other countries",
  "요즘 사회는 말에 너무 민감하다"                                 = "Our society these days tends to overreact even to a single word",
  "인류 대부분이 사라지는 상상을 한다"                             = "I sometimes imagine most of humanity disappearing, leaving only a few to start over",
  "좋고 멋진 것을 파괴하고 싶은 충동을 느낀다"                    = "I sometimes feel the urge to destroy beautiful things",
  "차별금지법은 도입되어야 한다"                                   = "Anti-discrimination legislation should be enacted",
  "청소년에게 더 많은 훈육이 필요하다"                             = "Adolescents need more discipline",
  "어떤 사람이 약자나 취약한 위치에 있는 사람을 신경쓰거나 돌보는 것은 중요하다." = "Caring for the weak and vulnerable is important",
  "나와 같은 계층(소득, 자산)의 사람들은 충분히 보상을 받고 있다." = "People in my social class are fairly compensated",
  "나와 같은 세대의 사람들이 충분히 보상을 받고 있다."             = "My generation is fairly compensated",
  "고통받는 사람들에 대한 연민과 동정이 사람으로서 가장 중요한 덕목이다." = "Compassion and sympathy for those who suffer are the most important human virtues",
  "성공하기 위해서는 다른 사람을 눌러야 할 때도 있다"               = "Success sometimes requires pushing others down",
  "나는 인류의 대부분이 사라지고 소수의 사람들만 남아 새롭게 시작하는 상상을 하곤 한다." = "I sometimes imagine most of humanity disappearing, leaving only a few to start over",
  "우리는 다음 세대에 살기 좋은 세상을 물려주어야 한다."           = "We must leave a better world for the next generation",
  "아이를 갖는 것은 사회에 대한 의무다."                           = "Having children is a social obligation",
  "모든 사람들이 동등한 대우를 받는지 따져보는 것은 중요하다."     = "Ensuring everyone receives equal treatment is important",
  "동성애자나 외국인노동자, 장애인 등 사회적 약자와 소수자를 보호하고자 하는 사람들의 도덕적 우월감에 불편함을 느낀다." = "I feel uncomfortable with the moral superiority of those who advocate for minorities and the vulnerable",
  "나는 가끔 좋고 멋진 것들(beautiful things)을 파괴하고 싶은 충동을 느낀다." = "I sometimes feel the urge to destroy beautiful things",
  "어머니가 일을 하면, 아이들이 어려움을 겪는다."                 = "Children suffer when mothers work",
  "약자를 보호하고, 내가 모르는 사람들까지도 공정하게 대우하는 것이 중요하다." = "Treating the vulnerable fairly is important",
  "우리나라는 동성애자나 외국인노동자, 장애인 등 사회적 약자와 소수자를 보호하려는 노력이 과하다." = "Efforts to protect the vulnerable have gone too far",
  "기후위기 극복을 위해 지금보다 강한 규제를 시행해야 한다."        = "Strong regulations are needed to address climate change",
  "명절 연휴에 제사를 안 지내고 해외여행을 가는 것은 비난받을 일이 아니다." = "Going abroad on holiday breaks without holding memorial rites is not something to be criticized",
  "요즘 우리 사회는 말 한마디에도 너무 민감하게 반응하는 경향이 있다." = "Our society these days tends to overreact even to a single word",
  "나는 사회가 완전히 무너져야 한다고 생각한다."                   = "I think society needs to completely collapse",
  "정부가 법을 제정할 때 첫번째 원칙은 모든 사람이 공평하게 대우받도록 하는 것이어야 한다." = "Fair treatment should be the first principle of legislation",
  "결혼은 반드시 해야 하는 것이 아니라 개인의 선택이다."           = "Marriage is not an obligation — it is a personal choice",
  "우리나라를 망쳐놓고 있는 극단주의를 제압할 수 있는 강력한 지도자가 필요하다" = "We need a strong leader to suppress the extremism that is ruining our country",
  "우리는 사회 제도의 문제를 해결할 수 없으므로, 이를 완전히 허물고 다시 시작해야 한다." = "Since we cannot fix social institutions, they must be torn down and rebuilt from scratch",
  "부정행위를 저지른 사람이 적발되어 처벌받을 때 기분이 좋다."     = "It feels good when wrongdoers are caught and punished",
  "요즈음 청소년들에게는 더 많은 훈육이 있어야만 한다."             = "Adolescents need more discipline",
  "모든 사람이 삶에서 동일한 양의 지원을 받아야 한다."             = "Everyone should receive the same level of life support",
  "일도 좋지만 여성이 우선순위를 둬야하는 것은 가정과 아이들이다." = "Work is fine, but women should prioritize family and children",
  "성별·장애·병력·나이·종교·성적 지향 등에 대한 차별을 금지하는 차별금지법은 도입돼야 한다." = "Anti-discrimination legislation should be enacted",
  "모든 사람이 동일한 금액의 돈을 번다면 세상은 더 나은 곳이 될 것이다." = "The world would be better if everyone earned the same",
  "가족보다 개인의 직업적 성공이 더 중요하다."                     = "Career success matters more than family",
  "나는 외국에서 자연재해가 발생하면 짜릿함을 느낀다."             = "I feel a thrill at natural disasters in other countries",
  "모든 사람이 평등하게 대우 받는 것이 중요하다."                   = "Equal treatment for all people is important",
  "노력하는 만큼 소득에 차이가 나야 한다."                         = "Income differences should reflect effort",
  "세상에는 상대적으로 남보다 더 우월한 사람들이 있다"             = "Some people are inherently superior to others",
  "부는 개인의 노력보다 운에 의해 결정된다."                       = "Wealth is determined more by luck than by effort",
  "부유해지는 것은 삶의 가장 중요한 목표다."                        = "Becoming wealthy is the most important goal in life"
)

# ── Keyword / Category translations ─────────────────────────────────────────
# Recategorised for clearer thematic grouping
keyword_en <- c(
  "개인주의"     = "Individualism",
  "과민성"       = "Social Sensitivity Backlash",
  "권위주의"     = "Authoritarianism",
  "기후위기"     = "Climate Policy",
  "능력주의"     = "Meritocracy",
  "물질주의"     = "Materialism",
  "미래"         = "Intergenerational Responsibility",
  "보상"         = "Generational & Class Grievance",
  "약자보호"     = "Protection of the Vulnerable",
  "연민"         = "Compassion",
  "전통"         = "Tradition & Custom",
  "젠더"         = "Gender & Family Roles",
  "차별금지"     = "Anti-Discrimination",
  "처벌쾌감"     = "Retributive Justice",
  "파괴욕구"     = "Social Alienation",
  "평등"         = "Procedural Equality",
  "훈육"         = "Discipline & Order",
  "공감 헤모글로빈" = "Empathy",
  "구조 백혈구"     = "Social Order",
  "정체성 단백"     = "Identity & Class",
  "우열 수용체"     = "Hierarchy & Merit"
)

# ── Age group labels ─────────────────────────────────────────────────────────
age_en <- c(
  "20대" = "20s",
  "30대" = "30s",
  "40대" = "40s",
  "50대" = "50s",
  "60대" = "60s",
  "70대" = "70s",
  "70대 이상" = "70s"
)

age_order <- c("20s", "30s", "40s", "50s", "60s", "70s")

# ── Gender labels ────────────────────────────────────────────────────────────
gender_en <- c(
  "M" = "Male",
  "W" = "Female",
  "남성" = "Male",
  "여성" = "Female"
)

# ── Likert scale labels ──────────────────────────────────────────────────────
likert_labels <- c(
  "전혀 그렇지 않다" = "Strongly Disagree",
  "그렇지 않다"      = "Disagree",
  "보통이다"         = "Neutral",
  "그렇다"           = "Agree",
  "매우 그렇다"      = "Strongly Agree"
)

likert_order <- c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree")
