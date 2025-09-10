import Foundation
import MagnusDomain

public class EventDetailsJsonMockGenerator {
    public static func generateObject() -> ConferenceEventDetails? {

        do {
            let data = Data(json.utf8)
            let decoder = JSONDecoder()
            return try decoder.decode(ConferenceEventDetails.self, from: data)
        } catch {
            print("Failed to decode JSON: \(error)")
            // Fallback to existing mock on decode failure
            return nil
        }
    }

    public static func generateObjectChM() -> ConferenceEventDetails? {

        do {
            let data = Data(jsonChm.utf8)
            let decoder = JSONDecoder()
            return try decoder.decode(ConferenceEventDetails.self, from: data)
        } catch {
            print("Failed to decode JSON: \(error)")
            // Fallback to existing mock on decode failure
            return nil
        }
    }

    static let json: String = #"""
        {
        "title": "Pierwsze wydarzenie",
        "date_from": "2025-10-01",
        "date_to": "2025-10-03",
        "image": "https://nncv2-dev.serwik.pl/images/th-4109958356.jpeg",
        "name": "Pierwsze wydarzenie",
        "description": "Spotkanie cykliczne 2025 Warszawa",
        "location": {
            "name": "Novotel Warszawa Centrum",
            "city": "Warszawa",
            "zip_code": "00-510",
            "street": "Marszałkowska 94/98",
            "latitude": "52.229367",
            "longitude": "21.013171",
            "image": "https://nncv2-dev.serwik.pl/images/Novotel_Warszawa.jpeg",
            "phone": "+48 22 548 42 72",
            "email": "H3383@accor.com",
            "www": "https://all.accor.com/booking/pl/novotel/hotels/warsaw-poland?compositions=1&stayplus=false&order_hotels_by=RECOMMENDATION&snu=false&hideWDR=false&productCode=null&accessibleRooms=false&hideHotelDetails=false&filters=eyJicmFuZHMiOlsiTk9WIl19&utm_term=mar&utm_campaign=ppc-nov-mar-msn-pl-pl-ee_ai-mix-sear&utm_medium=cpc&msclkid=4078f0543dce1ea8ccb798db5d8bb6c4&utm_source=bing&utm_content=pl-pl-PL-V4333",
            "header_description": "Sala bursztynowa",
            "description": "Hotel, który sprawia, że liczy się każda chwila\n\nZarezerwuj pokój w czterogwiazdkowym Novotel Warszawa Centrum ze wspaniałymi widokami na tętniącą życiem Warszawę. Hotel położony jest tylko 5 minut spacerem od Dworca Centralnego, a bliskość zabytków, sklepów i instytucji kultury zachęcają do zwiedzania. Wyśmienite jedzenie gwarantują hotelowy bar i restauracja. Śniadania są serwowane w dwóch restauracjach, na poziomie 0 oraz -1. W Novotelu dbamy również o udane spotkania biznesowe, a naszym gościom oferujemy doskonale wyposażone centrum konferencyjne.\n\nHotel Novotel Warszawa Centrum (hotel średniej klasy dla biznesu i rodziny) mieści się w samym centrum Warszawy niedaleko słynnego Pałacu Kultury i Nauki. Znajdujący się przy hotelu węzeł komunikacyjny (metro, autobusy i tramwaje) zapewnia dobrą komunikację z głównymi atrakcjami stolicy. Do hotelu można dojechać tramwajem z oddalonego o 500 m dworca, a z Lotniska Chopina kursuje bezpośredni autobus oraz Szybka Kolej Miejska. Podróż trwa ok. 25 min. Główne drogi dojazdowe to E30 i E77.\n\nZarezerwuj pokój w czterogwiazdkowym Novotel Warszawa Centrum ze wspaniałymi widokami na tętniącą życiem Warszawę. Wyśmienite jedzenie gwarantują hotelowy bar i restauracja. W Novotelu dbamy również o udane spotkania biznesowe i konferencje."
        },
        "guardians": [
            {
                "name": "Ewa Opiekun 1",
                "email": "user4@test.pl",
                "phone": "+48689456123"
            },
            {
                "name": "Jacek Opiekun 2",
                "email": "user5@test.pl",
                "phone": "+48689456124"
            }
        ],
        "agenda": [
            {
                "id": "eyJpZCI6MSwidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "date": "2025-10-01",
                "day": 1,
                "content": [
                    {
                        "time_from": "10:00:00",
                        "time_to": "10:45:00",
                        "place": "Sala niebieska",
                        "title": "Rozpoczęcie",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "11:00:00",
                        "time_to": "11:45:00",
                        "place": "Sala niebieska",
                        "title": "Sesja 1",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 1,
                        "is_online": 0
                    },
                    {
                        "time_from": "12:00:00",
                        "time_to": "12:45:00",
                        "place": "Sala niebieska",
                        "title": "Sesja 2",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "13:00:00",
                        "time_to": "13:45:00",
                        "place": "Sala niebieska",
                        "title": "Warsztaty",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "17:00:00",
                        "time_to": "17:45:00",
                        "place": "Sala niebieska",
                        "title": "sesja 3",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "18:00:00",
                        "time_to": "18:45:00",
                        "place": "Sala niebieska",
                        "title": "sesja 4",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    }
                ]
            },
            {
                "id": "eyJpZCI6MiwidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "date": "2025-10-02",
                "day": 2,
                "content": [
                    {
                        "time_from": "10:00:00",
                        "time_to": "10:45:00",
                        "place": "Sala zielona",
                        "title": "Sesja 1",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "11:00:00",
                        "time_to": "11:45:00",
                        "place": "Sala zielona",
                        "title": "Sesja 2",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "12:00:00",
                        "time_to": "12:45:00",
                        "place": "Sala zielona",
                        "title": "Sesja 3",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "13:00:00",
                        "time_to": "13:45:00",
                        "place": "Sala zielona",
                        "title": "Warsztaty",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "17:00:00",
                        "time_to": "17:45:00",
                        "place": "Sala zielona",
                        "title": "sesja 4",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "18:00:00",
                        "time_to": "18:45:00",
                        "place": "Sala niebieska",
                        "title": "sesja 5",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    }
                ]
            },
            {
                "id": "eyJpZCI6MywidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "date": "2025-10-03",
                "day": 3,
                "content": [
                    {
                        "time_from": "10:00:00",
                        "time_to": "10:45:00",
                        "place": "Sala niebieska",
                        "title": "Podsumowanie",
                        "speakers": "Andrzej Borek",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    },
                    {
                        "time_from": "11:00:00",
                        "time_to": "11:45:00",
                        "place": "Sala niebieska",
                        "title": "Pożegnanie",
                        "speakers": "",
                        "presenters": "Novo Nordisk",
                        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        "is_quiz": 0,
                        "is_online": 0
                    }
                ]
            }
        ],
        "dinner": {
            "name": "Beef and Pepper Steak house",
            "city": "Warszawa",
            "zip_code": "00-695",
            "street": "Nowogrodzka 47A",
            "latitude": "52.227912518998124",
            "longitude": "21.008327935582265",
            "image": "https://nncv2-dev.serwik.pl/images/OIP-2845708344.jpeg",
            "phone": "+48 785 025 025",
            "email": "",
            "www": "https://beefandpepper.pl/",
            "header_description": "Beef and Pepper Steak house - Restauracja Warszawa",
            "description": "Restauracja Beef and Pepper specjalizuje się w stekach z wołowiny. Serwujemy jedne z najlepszych steków wołowych w Warszawie. Mięso grillujemy na grillu z lawą wulkaniczną, grill jest opalany ogniem, co sprawia, że steki mają niepowtarzalny smak. W naszym menu znajdziecie również ryby i owoce morza, sałatki oraz dania z drobiu. W karcie znajdują się również desery a czekoladowa kula z lodami i słonym karmelem jest obowiązkiem w Beef and Pepper. Nasz szeroko zaopatrzony w alkohole i wina bar zadowoli każdego Gościa. Profesjonalni barmani przygotują koktajl według Państwa preferencji smakowych. Gwarantujemy świetną kolację w miłej atmosferze oraz profesjonalną załogą! Pozdrawiamy i zapraszamy serdecznie 😊 "
        },
        "materials": [
            {
                "id": "eyJpZCI6MiwidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "name": "Pięć kroków do bezpiecznej żywności",
                "file_type": 1,
                "link": "https://nncv2-dev.serwik.pl/materials/piec-krokowk-do-bezpieczniejszej-zywnosci.pdf",
                "publication_date": "2025-06-04 13:20:00"
            }
        ],
        "photo_booth": [
            {
                "id": "eyJpZCI6MSwidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "image": "https://nncv2-dev.serwik.pl/images/1_Gratulujemy_Zwyciezcom_CDC_Poland.jpg"
            },
            {
                "id": "eyJpZCI6MiwidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "image": "https://nncv2-dev.serwik.pl/images/th-4109958356.jpeg"
            },
            {
                "id": "eyJpZCI6MywidG9rZW4iOiIxNnxSNWJvN2l5NFJ0RnE1aE9YbmYzY3Q5c2NmWG5MNFJwV0pUQk1PYXJzN2UwNjhlYTUifQ==",
                "image": "https://nncv2-dev.serwik.pl/images/image_photo_1755021416.jpg"
            }
        ]
    }
    """#


    static let jsonChm: String = #"""
    {
    "title": "STOPA I STAW SKOKOWY",
    "date_from": "2025-09-12",
    "date_to": "2025-09-13",
    "image": "https://chm2-dev.serwik.pl/images/OIP-3223226002.jpeg",
    "name": "STOPA I STAW SKOKOWY",
    "description": "Kurs praktyczny na sztucznych kościach",
    "location": {
        "name": "Centrum Konferencyjno-Wypoczynkowe Pałac i Folwark Łochów",
        "city": "Łochów",
        "zip_code": "07-130",
        "street": "ul.Marii Konopnickiej 1 i 10",
        "latitude": "52.51536102894889",
        "longitude": "21.699441538540018",
        "image": "https://chm2-dev.serwik.pl/images/OIP-3223226002.jpeg",
        "phone": "+48 797 339 329",
        "email": "recepcja@folwarklochow.pl",
        "www": "https://www.palacifolwarklochow.pl/",
        "header_description": "Pałac i Folwark",
        "description": "Pałac i Folwark Łochów położony jest zaledwie godzinę jazdy od Warszawy drogą S8, w sercu Nadbużańskiego Parku Krajobrazowego, nad rzeką Liwiec, na terenie o powierzchni 40ha."
    },
    "guardians": [
        {
            "name": "Ewa Opiekun 1",
            "email": "user4@test.pl",
            "phone": "+48689456123"
        },
        {
            "name": "Jacek Opiekun 2",
            "email": "user5@test.pl",
            "phone": "+48689456124"
        }
    ],
    "agenda": [
        {
            "id": "eyJpZCI6MSwidG9rZW4iOiI3fGVRRUlNblkzM1RvYXJzRmxtdTBjanhnY245ZlEwZmpYS3pUQlk2ZzliNjA5MzFkNSJ9",
            "date": "2025-09-12",
            "day": 1,
            "content": [
                {
                    "time_from": "10:30:00",
                    "time_to": "11:00:00",
                    "place": "",
                    "title": "Rejestracja",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "11:00:00",
                    "time_to": "11:30:00",
                    "place": "",
                    "title": "Rozpoczęcie kursu. Prezentacja firmy ChM",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 1,
                    "is_online": 0
                },
                {
                    "time_from": "11:30:00",
                    "time_to": "12:00:00",
                    "place": "",
                    "title": "Obrazowanie stawu skokowego i stopy",
                    "speakers": "dr Andrzej Komor",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "12:00:00",
                    "time_to": "12:30:00",
                    "place": "",
                    "title": "Złamania typu tibial pilon – taktyka postępowania",
                    "speakers": "dr hab. n. med. Henryk Liszka",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "12:30:00",
                    "time_to": "13:00:00",
                    "place": "",
                    "title": "Artroza stawu skokowego – taktyka postępowania",
                    "speakers": "dr Andrzej Komor",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "13:00:00",
                    "time_to": "14:00:00",
                    "place": "",
                    "title": "Lunch",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "14:00:00",
                    "time_to": "14:30:00",
                    "place": "",
                    "title": "Panartrodeza tyłostopia z użyciem gwoździa piszczelowego wstecznego Charfix",
                    "speakers": "dr Andrzej Komor",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "14:30:00",
                    "time_to": "15:00:00",
                    "place": "",
                    "title": "Złamania kości piętowej – taktyka postępowania",
                    "speakers": "dr Jarosław Blicharz",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "15:00:00",
                    "time_to": "15:30:00",
                    "place": "",
                    "title": "Gwóźdź piętowy – wskazania i technika operacyjna",
                    "speakers": "dr Jarosław Blicharz",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "15:30:00",
                    "time_to": "16:00:00",
                    "place": "",
                    "title": "Przerwa kawowa",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "16:00:00",
                    "time_to": "16:30:00",
                    "place": "",
                    "title": "Uszkodzenia stawu Lisfranca – taktyka postępowania",
                    "speakers": "dr Andrzej Komor",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "16:30:00",
                    "time_to": "19:30:00",
                    "place": "",
                    "title": "Warsztaty na sztucznych kościach",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "20:00:00",
                    "time_to": "23:00:00",
                    "place": "",
                    "title": "Kolacja",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                }
            ]
        },
        {
            "id": "eyJpZCI6MiwidG9rZW4iOiI3fGVRRUlNblkzM1RvYXJzRmxtdTBjanhnY245ZlEwZmpYS3pUQlk2ZzliNjA5MzFkNSJ9",
            "date": "2025-09-13",
            "day": 2,
            "content": [
                {
                    "time_from": "09:00:00",
                    "time_to": "09:30:00",
                    "place": "",
                    "title": "Paluch koślawy – diagnostyka i leczenie",
                    "speakers": "dr Andrzej Komor",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "09:30:00",
                    "time_to": "10:00:00",
                    "place": "",
                    "title": "Płytka do osteotomii dystalnej MT1 – moje doświadczenia",
                    "speakers": "dr n. med. Jan Kiryluk",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "10:00:00",
                    "time_to": "10:30:00",
                    "place": "",
                    "title": "Mini-inwazyjna przezskórna korekcja przodostopia",
                    "speakers": "dr hab. n. med. Henryk Liszka",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "10:30:00",
                    "time_to": "11:00:00",
                    "place": "",
                    "title": "",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "11:00:00",
                    "time_to": "11:30:00",
                    "place": "",
                    "title": "`Płaskostopie` czyli Foot Collapsing Deformity – taktyka postępowania",
                    "speakers": "dr hab. n. med. Henryk Liszka",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "11:30:00",
                    "time_to": "12:00:00",
                    "place": "",
                    "title": "Artroereza – moje doświadczenia",
                    "speakers": "dr hab. n. med. Henryk Liszka",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "12:00:00",
                    "time_to": "13:00:00",
                    "place": "",
                    "title": "Lunch",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "13:00:00",
                    "time_to": "15:30:00",
                    "place": "",
                    "title": "Warsztaty",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                },
                {
                    "time_from": "15:30:00",
                    "time_to": "17:30:00",
                    "place": "",
                    "title": "Uroczyste zakończenie kursu",
                    "speakers": "",
                    "presenters": "",
                    "description": "",
                    "is_quiz": 0,
                    "is_online": 0
                }
            ]
        }
        ],
        "dinner": {
            "name": "Centrum Konferencyjno-Wypoczynkowe Pałac i Folwark Łochów",
            "city": "Łochów",
            "zip_code": "07-130",
            "street": "ul.Marii Konopnickiej 1 i 10",
            "latitude": "52.51536102894889",
            "longitude": "21.699441538540018",
            "image": "https://chm2-dev.serwik.pl/images/OIP-2933743797.jpeg",
            "phone": "+48 797 339 329",
            "email": "recepcja@folwarklochow.pl",
            "www": "https://www.palacifolwarklochow.pl/",
            "header_description": "Restauracja U Zamoyskiego – tradycja, smak i wyjątkowa atmosfera.",
            "description": "Restauracja U Zamoyskiego serdecznie zaprasza do odkrywania smaków tradycyjnej kuchni polskiej oraz regionalnych specjałów inspirowanych bogactwem Mazowsza. Nasz lokal mieści się w urokliwym budynku, pieczołowicie odrestaurowanym z zachowaniem stylu pałacowego, co tworzy niepowtarzalny klimat i wyjątkową atmosferę.\nTo d        oskonałe miejsce zarówno na rodzinny obiad, spotkanie biznesowe, wieczór z przyjaciółmi, jak i organizację przyjęcia okolicznościowego. "
        },
        "materials": [],
        "photo_booth": [
            {
                "id": "eyJpZCI6MSwidG9rZW4iOiI3fGVRRUlNblkzM1RvYXJzRmxtdTBjanhnY245ZlEwZmpYS3pUQlk2ZzliNjA5MzFkNSJ9",
                "image": "https://chm2-dev.serwik.pl/images/th-4109958356.jpeg"
            }
        ]
    }
    """#
}