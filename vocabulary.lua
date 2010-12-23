local M = {}

M.vocabularies = {
	{
		name = "JfBP I",
		levels =
		{
			{ -- JfBP I: LEVEL 1 --
				{ kana = {"~","sa","n"}, eng = "Mr., Mrs., Miss", kana_type = "hiragana" },
				{ kana = {"ko","chi","ra"}, eng = "This one, this person", kana_type = "hiragana" },
				{ kana = {"de","su"}, eng = "Be, is", kana_type = "hiragana" },
				{ kana = {"be","n","go","shi"}, eng = "Attorney, lawyer", kana_type = "hiragana" },
				{ kana = {"ha","ji","me","ma","shi","te"}, eng = "How do you do", kana_type = "hiragana" },
				{ kana = {"yo","ro","shi","ku","","o","ne","ga","i","shi", "ma", "su"}, eng = "Pleased to meet you", kana_type = "hiragana" },
				{ kana = {"de","pa","-","to"}, eng = "Department store", kana_type = "katakana" },

				{ kana = {"ni","ho","n"}, eng = "Japan", kana_type = "hiragana" },
				{ kana = {"chu","u","go","ku"}, eng = "China", kana_type = "hiragana" },
				{ kana = {"do","i","tsu"}, eng = "Germany", kana_type = "katakana" },
				{ kana = {"i","gi","ri","su"}, eng = "the United Kingdom", kana_type = "katakana" },
				{ kana = {"a","me","ri","ka"}, eng = "the United States", kana_type = "katakana" },
				{ kana = {"o","-","su","to","ra","ri","a"}, eng = "Australia", kana_type = "katakana" },
				{ kana = {"ta","i"}, eng = "Thailand", kana_type = "katakana" },
				{ kana = {"~","ji","n"}, eng = "-ese, -ian, person from", kana_type = "hiragana" },

				{ kana = {"hi","sho"}, eng = "Secretary", kana_type = "hiragana" },
				{ kana = {"ga","ku","se","i"}, eng = "Student", kana_type = "hiragana" },
				{ kana = {"e","n","ji","ni","a"}, eng = "Engineer", kana_type = "katakana" },

				{ kana = {"ha","i"}, eng = "Yes", kana_type = "hiragana" },
				{ kana = {"i","i","e"}, eng = "No", kana_type = "hiragana" },

				{ kana = {"a","na","ta"}, eng = "You", kana_type = "hiragana" },
				{ kana = {"ro","n","do","n"}, eng = "London", kana_type = "katakana" },
				{ kana = {"gi","n","ko","u"}, eng = "Bank", kana_type = "hiragana" },
				{ kana = {"to","u","kyo","u"}, eng = "Tokyo", kana_type = "hiragana" },
				{ kana = {"da","i","ga","ku"}, eng = "University, College", kana_type = "hiragana" },
				{ kana = {"o","ne","ga","i","shi","ma","su"}, eng = "Please", kana_type = "hiragana" },
				{ kana = {"u","ke","tsu","ke"}, eng = "Reception desk, receptionist", kana_type = "hiragana" },

				{ kana = {"do","na","ta"}, eng = "Who", kana_type = "hiragana" },
				{ kana = {"ha","i","","do","u","zo"}, eng = "Please go ahead, feel free", kana_type = "hiragana" },
			},
			
			{ -- JfBP I: LEVEL 2 --
				{ kana = {"wa","ta","shi","no"}, eng = "My", kana_type = "hiragana" },
				{ kana = {"me","i","shi"}, eng = "Business card", kana_type = "hiragana" },
				{ kana = {"do","u","zo"}, eng = "Please, if you please", kana_type = "hiragana" },
				{ kana = {"do","u","mo","","a","ri","ga","to","u","go","za","i","ma","su"}, eng = "Thank you very much", kana_type = "hiragana" },
				{ kana = {"ko","re"}, eng = "This one", kana_type = "hiragana" },
				{ kana = {"na","ma","e"}, eng = "Name", kana_type = "hiragana" },
				{ kana = {"e","e"}, eng = "Yes, less formal", kana_type = "hiragana" },
				{ kana = {"so","u","de","su"}, eng = "That's right", kana_type = "hiragana" },
				{ kana = {"ko","re","ha","?"}, eng = "What about this?", kana_type = "hiragana" },
				{ kana = {"ka","i","sha"}, eng = "Company, the office", kana_type = "hiragana" },

				{ kana = {"ju","u","sho"}, eng = "Address", kana_type = "hiragana" },
				{ kana = {"de","n","wa","ba","n","go","u"}, eng = "Telephone number", kana_type = "hiragana" },
				{ kana = {"de","n","wa"}, eng = "Telephone", kana_type = "hiragana" },
				{ kana = {"ba","n","go","u"}, eng = "Number", kana_type = "hiragana" },
				{ kana = {"me","-","ru","a","do","re","su"}, eng = "E-mail address", kana_type = "katakana" },

				{ kana = {"ke","i","ta","i"}, eng = "Cell phone", kana_type = "hiragana" },
				{ kana = {"ka","sa"}, eng = "Umbrella", kana_type = "hiragana" },
				{ kana = {"ho","n"}, eng = "Book", kana_type = "hiragana" },
				{ kana = {"shi","n","bu","n"}, eng = "Newspaper", kana_type = "hiragana" },
				{ kana = {"ka","gi"}, eng = "Key", kana_type = "hiragana" },
				{ kana = {"to","ke","i"}, eng = "Watch, clock", kana_type = "hiragana" },
				{ kana = {"de","ha","a","ri","ma","se","n"}, eng = "Is/Are not", kana_type = "hiragana" },

				{ kana = {"na","n"}, eng = "What", kana_type = "hiragana" },

				{ kana = {"da","re"}, eng = "Who", kana_type = "hiragana" },

				{ kana = {"ta","i","shi","ka","n"}, eng = "Embassy", kana_type = "hiragana" },
				{ kana = {"na","n","ba","n"}, eng = "What number", kana_type = "hiragana" },

				{ kana = {"te","cho","u"}, eng = "Datebook, small notebook, planner", kana_type = "hiragana" },

				{ kana = {"su","mi","ma","se","n"}, eng = "I'm sorry, excuse me", kana_type = "hiragana" },
				{ kana = {"mo","u","","i","chi","do"}, eng = "One more time", kana_type = "hiragana" },
				{ kana = {"mo","u"}, eng = "More", kana_type = "hiragana" },
				{ kana = {"i","chi","do"}, eng = "One time", kana_type = "hiragana" },
			},
			
			{ -- JfBP I: LEVEL 3 --
				{ kana = {"i","ma"}, eng = "Now", kana_type = "hiragana" },
				{ kana = {"na","n","ji"}, eng = "What time", kana_type = "hiragana" },
				{ kana = {"~","ji"}, eng = "O'clock (counter)", kana_type = "hiragana" },
				{ kana = {"o","n","na","no","","hi","to"}, eng = "Woman", kana_type = "hiragana" },
				{ kana = {"o","n","na"}, eng = "Female, woman", kana_type = "hiragana" },
				{ kana = {"hi","to"}, eng = "Person", kana_type = "hiragana" },
				{ kana = {"~","fu","n","","~","pu","n"}, eng = "Minute", kana_type = "hiragana" },

				{ kana = {"su","-","pa","-"}, eng = "Supermarket", kana_type = "katakana" },
				{ kana = {"re","su","to","ra","n"}, eng = "Restaurant", kana_type = "katakana" },
				{ kana = {"yu","u","bi","n","kyo","ku"}, eng = "Post office", kana_type = "hiragana" },
				{ kana = {"gi","n","ko","u"}, eng = "Bank", kana_type = "hiragana" },
				{ kana = {"shi","go","to"}, eng = "Work, job", kana_type = "hiragana" },
				{ kana = {"ka","i","gi"}, eng = "Meeting, conference", kana_type = "hiragana" },
				{ kana = {"hi","ru","ya","su","mi"}, eng = "Lunch break", kana_type = "hiragana" },
				{ kana = {"hi","ru"}, eng = "Noon", kana_type = "hiragana" },
				{ kana = {"ya","su","mi"}, eng = "Break, rest", kana_type = "hiragana" },
				{ kana = {"pa","-","te","i","-"}, eng = "Party", kana_type = "katakana" },
				{ kana = {"e","i","ga"}, eng = "Movie", kana_type = "hiragana" },

				{ kana = {"ha","n"}, eng = "Half past (time)", kana_type = "hiragana" },
				{ kana = {"go","ze","n"}, eng = "In the morning, a.m.", kana_type = "hiragana" },

				{ kana = {"a","sa","go","ha","n"}, eng = "Breakfast", kana_type = "hiragana" },
				{ kana = {"a","sa"}, eng = "Morning", kana_type = "hiragana" },
				{ kana = {"go","ha","n"}, eng = "Meal", kana_type = "hiragana" },
				{ kana = {"fu","ro","n","to"}, eng = "The front desk (hotel)", kana_type = "katakana" },
				{ kana = {"do","u","mo","","a","ri","ga","to","u"}, eng = "Thank you", kana_type = "hiragana" },
				{ kana = {"ba","n","go","ha","n"}, eng = "Dinner", kana_type = "hiragana" },
				{ kana = {"ba","n"}, eng = "Evening", kana_type = "hiragana" },
				{ kana = {"pu","-","ru"}, eng = "Pool", kana_type = "katakana" },
				{ kana = {"ji","mu"}, eng = "Gym", kana_type = "katakana" },

				{ kana = {"so","u","de","su","ka"}, eng = "I see", kana_type = "hiragana" },
			},
			
			{ -- JfBP I: LEVEL 4 --
				{ kana = {"mi","se"}, eng = "Shop, store, restaurant", kana_type = "hiragana" },
				{ kana = {"i","ra","xtsu","sha","i","ma","se"}, eng = "May I help you?, welcome", kana_type = "hiragana" },
				{ kana = {"so","re"}, eng = "That one", kana_type = "hiragana" },
				{ kana = {"mi","se","te","ku","da","sa","i"}, eng = "Please show me", kana_type = "hiragana" },
				{ kana = {"i","ku","ra"}, eng = "How much", kana_type = "hiragana" },
				{ kana = {"~","e","n"}, eng = "Yen", kana_type = "hiragana" },
				{ kana = {"ja"}, eng = "Well then", kana_type = "hiragana" },
				{ kana = {"ku","da","sa","i"}, eng = "Please give me", kana_type = "hiragana" },

				{ kana = {"te","re","bi"}, eng = "Television", kana_type = "katakana" },
				{ kana = {"ra","ji","o"}, eng = "Radio", kana_type = "katakana" },
				{ kana = {"pa","so","ko","n"}, eng = "Personal computer", kana_type = "katakana" },
				{ kana = {"de","ji","ka","me"}, eng = "Digital camera", kana_type = "katakana" },
				{ kana = {"bi","de","o","ka","me","ra"}, eng = "Video camera", kana_type = "katakana" },
				{ kana = {"bi","de","o"}, eng = "Video", kana_type = "katakana" },
				{ kana = {"ka","me","ra"}, eng = "Camera", kana_type = "katakana" },

				{ kana = {"a","re"}, eng = "That one over there", kana_type = "hiragana" },

				{ kana = {"za","xtsu","shi"}, eng = "Magazine", kana_type = "hiragana" },

				{ kana = {"sha","-","pu","pe","n","shi","ru"}, eng = "Mechanical pencil", kana_type = "katakana" },
				{ kana = {"bo","-","ru","pe","n"}, eng = "Ballpoint pen", kana_type = "katakana" },
				{ kana = {"fu","ra","n","su"}, eng = "France", kana_type = "katakana" },
				{ kana = {"~","go"}, eng = "Language", kana_type = "hiragana" },
				{ kana = {"ji","sho"}, eng = "Dictionary", kana_type = "hiragana" },
				{ kana = {"e","i","go"}, eng = "English language", kana_type = "hiragana" },

				{ kana = {"ka","-","do"}, eng = "Card (credit card)", kana_type = "katakana" },
			},
			
			{ -- JfBP I: LEVEL 5 -- (not yet verified)
				{ kana = {"T","sha","tsu"}, eng = "T-shirt", kana_type = "katakana" },
				{ kana = {"do","re"}, eng = "Which one", kana_type = "hiragana" },
				{ kana = {"a","o","i"}, eng = "Blue", kana_type = "hiragana" },
				{ kana = {"a","ka","i"}, eng = "Red", kana_type = "hiragana" },
				{ kana = {"~","ma","i"}, eng = "Counter for flat objets", kana_type = "hiragana" },

--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },

			}
		}
	}
}

return M

