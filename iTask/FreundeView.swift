//
//  FreundeView.swift
//  iTask
//
//  Created by Thomas on 28.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import SwiftUI

struct FreundeView: View {
    //MARK: Muss irgendwo anders definiert werden
    let currUser = UserModel(id: "LgUZK2f", name: "Thomas Raab", aufgabe: 2, aktueller_streak: 3, letztes_erledigt_datum: "2020-05-29", anzahl_benachrichtigungen: 0)
    
    let currAufgabe = AufgabeModel(id: 1, text: "Sprich mit einer fremden Person", text_dp: "Spricht mit einer fremden Person", detailtext: "Fördere deine Sozialkompetenz, indem du mit einer Person sprichst, mit der du vorher noch nie gesprochen hast. Zum Beispiel dein Postbote, jemand beim Einkaufen usw.", kategorie: "Social", autor: "admin", ausgespielt: 1, erledigt: 0, abgelehnt: 0, aufgeschoben: 0)
    
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            
            HStack {
                Text("Freunde").fontWeight(.heavy).font(.largeTitle)
                Spacer()
                Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(.blue)
            }.padding(.horizontal)
            .padding(.top,92)
            
            Form {
                Section(header: Text("DEIN FREUNDESCODE")) {
                    HStack {
                        Text(currUser.id)
                        Spacer()
                        Button(action: {
                            UIPasteboard.general.string = self.currUser.id
                        }) {
                            Text("Kopieren")
                        }
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            print("Freunde hinzufügen tapped")
                        }) {
                            Text("Freunde hinzufügen")
                        }
                        Spacer()
                    }
                }
            }.padding(.top,20)
                .padding(.bottom, 15)
            
            Form {
                Section(header: HStack {
                    Text("FREUNDE")
                    Spacer()
                    Text("ERLEDIGTE AUFGABEN")
                    }) {
                     // TODO: Liste dynamisch füllen mit for schleife
                    List {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(currUser.name)
                                    .font(.headline)
                                Text(currAufgabe.text_dp)
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                            // TODO: Dynamisch machen
                            Text("6")
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text(currUser.name)
                                    .font(.headline)
                                Text(currAufgabe.text_dp)
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                            Text("22")
                        }
                    }
                }
            }
            //.padding([.top],30)
            //.padding(.bottom, 15)
            Form {
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Fordere deine Freunde raus tapped")
                        }) {
                            Text("Fordere deine Freunde heraus")
                        }
                        Spacer()
                    }
                }
            }.padding([.top],30)
            .padding(.bottom, 15)
            Spacer()
            .frame(height: 50)
            Spacer()
        }.background(Color(UIColor.secondarySystemBackground))
            .edgesIgnoringSafeArea([.top, .bottom])
        
    }
}

func freundeHinzufuegenTapped() {
    /*let ac = UIAlertController(title: "Hier Freundescode einfügen", message: nil, preferredStyle: .alert)
    ac.addTextField()

    let submitAction = UIAlertAction(title: "Hinzufügen", style: .default) { [unowned ac] _ in
        let answer = ac.textFields![0]
        // do something interesting with "answer" here
 
    }

    ac.addAction(submitAction)

    self.present(ac, animated: true, completion: nil)
 */
}

struct FreundeView_Previews: PreviewProvider {
    static var previews: some View {
        FreundeView()
    }
}
