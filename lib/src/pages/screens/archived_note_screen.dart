part of screens;

class ArchivedScreen extends StatefulWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  _ArchivedScreenState createState() => _ArchivedScreenState();
}

class _ArchivedScreenState extends State<ArchivedScreen> {
  late final FirebaseManager fbm;
  late final User user ;

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<AuthenticationBloc>(context).state.user;
    fbm = FirebaseManager(user);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<NoteModel>?>(
          future: fbm.getAllArchivedNoteInCloud(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(snapshot.data!.isEmpty) {
              return Center(
                child: SizedBox(
                  height: 200,
                  child: Column(
                    children: const [
                      Icon(Icons.sentiment_dissatisfied_rounded, size: 100,),
                      SizedBox(height: 8.0,),
                      Text('No document archived')
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length ,
              itemBuilder: (context, i) => SizedBox(
                height: 120,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  color: Colors.grey.shade700.withOpacity(0.7),
                  child: ListTile(
                    //leading: const Icon(Icons.delete_sweep_outlined, size: 42,),
                    title: Text(
                      "${snapshot.data![i].title}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "${snapshot.data![i].text}",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),

                    onTap: () => Navigator.push(
                        context,
                        TextEditor.route(
                          note: snapshot.data![i],
                        ))
                    //onTap: (){},
                  ),
                ),
              )

            );
          }
      )
    );
  }
}
