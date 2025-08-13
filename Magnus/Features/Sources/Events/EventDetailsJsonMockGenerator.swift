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
}
