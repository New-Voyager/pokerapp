import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String title;
  final String text;
  const PrivacyPolicyScreen({Key key, this.title, this.text}) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String text = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus in viverra libero. Vestibulum facilisis lobortis blandit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed quis nisl varius, imperdiet dolor ut, condimentum tortor. Pellentesque ultrices, quam vitae viverra hendrerit, lorem tellus ullamcorper nunc, id condimentum augue ex ut nibh. Morbi sed fermentum dui, sed porttitor orci. Curabitur maximus arcu in fringilla ullamcorper. Mauris nec felis blandit, sollicitudin lectus at, semper erat.

Donec viverra tortor condimentum egestas rhoncus. Proin ut varius urna. Maecenas in elementum turpis. In eu mauris sed urna rutrum eleifend. Pellentesque ultrices velit at lectus suscipit vulputate. Ut eu tortor dolor. Nam lectus diam, suscipit a sodales et, auctor et lorem. Aliquam accumsan, ligula non dapibus congue, justo turpis molestie tellus, mollis finibus ante felis in magna. Suspendisse ex ante, convallis nec sem id, egestas feugiat ex. Nulla convallis rutrum mauris, et condimentum quam mattis vel. Aenean vitae nisi risus. Phasellus dignissim iaculis lectus. Donec vitae quam sed sapien pharetra scelerisque. Ut feugiat dapibus eros vel facilisis.

Curabitur dapibus volutpat magna sit amet condimentum. Phasellus venenatis lacus eget euismod sollicitudin. Ut ac tortor nibh. Vestibulum facilisis porta sollicitudin. Nulla finibus odio sit amet purus finibus euismod. Vestibulum imperdiet, quam luctus molestie blandit, nisl dolor feugiat massa, sed placerat tellus odio nec leo. Vivamus vitae porta nisl, eu eleifend urna. Praesent scelerisque erat in nulla pharetra, sed rutrum felis suscipit. Phasellus nec leo sed lacus viverra imperdiet. Ut convallis elit quis cursus vestibulum. Vivamus dui nunc, porttitor id hendrerit eu, mattis at enim.

Vivamus vel interdum odio. Vestibulum vel dictum eros, ac rhoncus orci. Nam ullamcorper suscipit felis et congue. Aliquam sit amet pretium velit, sit amet tempor justo. Vivamus venenatis tortor urna. Aenean eget pharetra nulla. Praesent felis elit, placerat id luctus molestie, mattis eu tortor. Praesent accumsan euismod felis, quis sagittis est porttitor eu. Nullam placerat sed lorem vitae sagittis. Donec nec quam turpis. Mauris eu augue quis purus consectetur porta eget sed leo. Vestibulum vestibulum imperdiet eros, vitae finibus mauris malesuada id.

Mauris tempus odio id lorem pharetra gravida. Praesent nec velit elementum nibh finibus tincidunt vel ac lorem. Donec eget suscipit mauris. Nullam quis facilisis nibh. Morbi vel erat posuere, sollicitudin diam eu, cursus felis. Etiam nec arcu dui. Vivamus a justo at augue vestibulum vulputate in vel lectus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Cras commodo augue enim, a tempor libero convallis vel. Proin euismod vitae nunc a rutrum. Fusce maximus mi nec magna accumsan semper. Proin at mollis mauris, sed feugiat metus.

Maecenas quis interdum ligula. Lorem ipsum dolor sit amet, consectetur adipiscing elit. In accumsan pretium ex et egestas. Nullam et diam ut mi hendrerit dictum. Quisque sit amet tempor sapien. Morbi id ipsum erat. Quisque sit amet bibendum nisl, et aliquet est. Phasellus tincidunt varius justo a interdum. Nam orci est, blandit nec justo posuere, malesuada accumsan nunc.

Duis iaculis mauris dapibus urna scelerisque, et vestibulum tortor aliquet. Phasellus vitae pellentesque dolor. Cras tristique lorem auctor tellus aliquam, eu accumsan dui pellentesque. Donec urna justo, imperdiet consectetur orci eu, aliquet maximus justo. Sed sem erat, hendrerit vitae malesuada a, porttitor sit amet sem. Sed tristique nec sapien euismod tempus. Vestibulum vestibulum dictum velit, non mollis velit rutrum sed. Fusce dolor risus, mattis varius lectus cursus, bibendum dapibus lorem.

Quisque quis euismod nibh. Praesent et tristique turpis. Curabitur semper augue non neque efficitur, id volutpat magna iaculis. Proin id massa sed justo luctus ultricies. Suspendisse aliquam dui sit amet libero euismod, a ultricies orci molestie. Morbi ut mauris sodales magna faucibus posuere. Fusce volutpat placerat condimentum. Sed in ligula suscipit, consectetur turpis sit amet, consequat justo. Sed euismod pharetra arcu, sit amet iaculis justo hendrerit id. Nunc dignissim justo libero, ultrices suscipit nunc accumsan vitae.

Duis et metus nunc. Ut tristique sapien sed purus tempus, non dapibus odio ultrices. Vestibulum ullamcorper vehicula ligula, ac consectetur diam cursus id. Suspendisse molestie posuere tellus, non blandit urna rutrum et. Maecenas convallis imperdiet lacus sed facilisis. Suspendisse rutrum odio non ante semper laoreet ut et purus. Duis imperdiet eu erat vitae efficitur. Vivamus massa est, tincidunt luctus nulla et, congue gravida elit. Fusce blandit lacus fringilla metus gravida laoreet. Duis vel feugiat sapien, at interdum nisi. Ut vel diam pharetra, commodo metus et, dapibus ipsum. In hac habitasse platea dictumst. Suspendisse iaculis vehicula semper. Donec ut justo et mi sagittis dignissim.

Vivamus non pretium arcu. Integer sed eleifend purus, eget convallis felis. Duis fermentum felis non auctor tincidunt. Donec molestie maximus lorem nec luctus. Nam feugiat suscipit mattis. Pellentesque hendrerit faucibus nisi, eu elementum dolor ornare ut. Etiam elementum arcu id tincidunt commodo. Suspendisse imperdiet enim nibh, ac bibendum lacus lacinia at. Pellentesque ante augue, laoreet at luctus sed, scelerisque eget est. Curabitur lobortis tellus sed sodales tincidunt. Nullam imperdiet enim et varius tincidunt. Proin quis libero eros. Integer a risus rutrum, suscipit metus tristique, auctor velit. Praesent sit amet nisl purus. Pellentesque sed diam sed magna lacinia interdum nec in metus.
  """;

  @override
  Widget build(BuildContext context) {
    if (widget.text != null) {
      text = widget.text;
    }
    final theme = AppTheme.getTheme(context);
    return Container(
      decoration: AppDecorators.bgRadialGradient(theme),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            context: context,
            titleText: widget.title ?? "Policy",
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Html(
                data: text,
              ),
              // child: Text(
              //   text,
              //   style: AppDecorators.getHeadLine4Style(theme: theme),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
