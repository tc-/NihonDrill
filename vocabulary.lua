local M = {}

M.vocabularies = {
	{
		name = "JfBP I",
		levels =
		{
			{ -- LEVEL 1 --
				{ kana = {"~","sa","n"}, eng = "Mr., Mrs., Miss", kana_type = "hiragana" },
				{ kana = {"ko","chi","ra"}, eng = "this one, this person", kana_type = "hiragana" },
				{ kana = {"de","su"}, eng = "be, is", kana_type = "hiragana" },
				{ kana = {"be","n","go","shi"}, eng = "attorney, lawyer", kana_type = "hiragana" },
				{ kana = {"ha","ji","me","ma","shi","te"}, eng = "how do you do", kana_type = "hiragana" },
				{ kana = {"yo","ro","shi","ku","","o","ne","ga","i","shi", "ma", "su"}, eng = "pleased to meet you", kana_type = "hiragana" },
				{ kana = {"de","pa","-","to"}, eng = "department store", kana_type = "katakana" },

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
			
			{ -- LEVEL 2 --
				{ kana = {"wa","ta","shi","no"}, eng = "My", kana_type = "hiragana" },
				{ kana = {"me","i","shi"}, eng = "Business card", kana_type = "hiragana" },
				{ kana = {"do","u","zo"}, eng = "Please, if you please", kana_type = "hiragana" },
				{ kana = {"do","u","mo","","a","ri","ga","to","u","go","za","i","ma","su"}, eng = "Thank you very much", kana_type = "hiragana" },
				{ kana = {"ko","re"}, eng = "This one", kana_type = "hiragana" },
				{ kana = {"na","ma","e"}, eng = "Name", kana_type = "hiragana" },
				{ kana = {"e","e"}, eng = "Yes, less formal", kana_type = "hiragana" },
				{ kana = {"so","u","de","su"}, eng = "that's right", kana_type = "hiragana" },
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

--				{ kana = {"","","","","",""}, eng = "", kana_type = "hiragana" },
			}
		}
	}
}

return M

