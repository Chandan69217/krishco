import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/widgets/cust_dialog_box/cust_dialog_box.dart';
import 'package:krishco/widgets/cust_loader.dart';
import 'package:krishco/widgets/cust_snack_bar.dart';

import 'approval_permissions.dart';

class ClaimActions extends StatefulWidget {
  final int claimId;
  final VoidCallback? onSuccess;
  final bool? permissionToCancel;
  final ApprovalPermissions? approvalPermissions;
  final bool? permissionToReject;

  ClaimActions({
    this.onSuccess,
    required this.claimId,
    this.permissionToCancel = true,
    this.approvalPermissions,
    this.permissionToReject = false,
  });

  @override
  _ClaimActionsState createState() => _ClaimActionsState();
}

class _ClaimActionsState extends State<ClaimActions> {
  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedAction;
  bool _isLoading = false;
  late String _approvalStatus;
  late final int claimAmount;

  @override
  void initState() {
    super.initState();
    if(widget.approvalPermissions != null){
      _approvalStatus = widget.approvalPermissions!.approvalStatus.first;
    }
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(widget.approvalPermissions != null && widget.approvalPermissions!.confirmed != null){
        claimAmount =  widget.approvalPermissions!.confirmed!.claimAmount;
        _claimAmountController.text = widget.approvalPermissions!.confirmed!.claimAmount.toString();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading?Center(child: CustLoader()):Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.approvalPermissions != null && _approvalStatus == 'Confirm')...[
            TextFormField(
              key: Key('Claim_Amount_Text'),
              validator: (v){
                if(v!=null){
                  if( ['rejected','cancelled'].contains(_selectedAction))return null;
                  final amount = int.tryParse(v)??0;
                  if(!(amount<= claimAmount|| amount==0)){
                    return 'Enter Claim amount less ${claimAmount}';
                  }else if(amount==0){
                    return 'Enter Claim Confirm amount';
                  }
                }
                return null;
              },
              onChanged: (x){
                _formKey.currentState!.validate();
              },
              controller: _claimAmountController,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Claim Confirm Amount',
                  prefixIcon: Icon(Icons.currency_rupee_rounded,size: 20,)
              ),
            ),
            const SizedBox(height: 8.0,),
          ],
          if(widget.permissionToCancel! || widget.approvalPermissions != null || widget.permissionToReject!)
            TextFormField(
              key: Key('Remark_Text'),
              validator: (v){
                if(_selectedAction != null && _selectedAction!.toLowerCase().contains('rejected')){
                  if(v == null || v.isEmpty){
                    return 'Please enter remarks';
                  }
                }
                if(_selectedAction != null && _selectedAction!.toLowerCase().contains('on_hold')){
                  if(v == null || v.isEmpty){
                    return 'Please enter remarks';
                  }
                }
                return null;
              },
              controller: _remarkController,
              decoration: InputDecoration(
                  labelText: 'Remarks'
              ),
              maxLines: 3,
            ),
          if(!(widget.permissionToCancel! || widget.approvalPermissions != null || widget.permissionToReject!))
            Center(
              child: Text('No Permission Allowed'),
            ),
          if(widget.approvalPermissions != null)...[
            const SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                      value: _approvalStatus,
                      elevation: 8,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 12.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200
                            )
                        ),
                      ),
                      isExpanded: true,
                      items: widget.approvalPermissions!.approvalStatus.map((e){
                        return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e)
                        );
                      }).toList(),
                      onChanged: (value){
                        if(value != null){
                          setState(() {
                            _approvalStatus = value;
                          });
                        }
                      }),
                ),
                SizedBox(width: 8.0,),
                Expanded(flex:1,child: ElevatedButton(onPressed: _onApprove, child: Text(_approvalStatus),
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      backgroundColor: WidgetStatePropertyAll(
                          _approvalStatus == 'On Hold' ? Colors.orange:Colors.green
                      )
                  ),
                ))
              ],
            ),
          ],
          if(widget.permissionToReject!)...[
            const SizedBox(height: 16.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _onRejected, child: Text('Reject'),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                        Colors.red
                    )
                ),
              ),
            ),
          ],
          if(widget.permissionToCancel!)...[
            const SizedBox(height: 16.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _onCancel, child: Text('Cancel'),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                        Colors.red
                    )
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  String _getApprovalStatusOnSection(String selection){
    switch(selection){
      case 'Confirm': return 'confirmed';
      case 'On Hold': return 'on_hold';
      case'Approve': return 'approved';
      default: return '';
    }
  }

  void _onApprove()async {
    _selectedAction = _getApprovalStatusOnSection(_approvalStatus);
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await APIService.getInstance(context).invoiceClaim.claimRecall(claimID: widget.claimId, finalClaimAmount: int.tryParse(_claimAmountController.text)??0, status: _selectedAction??'');
    if(response != null){
      final status = response['isScuss'];
      String message = response['messages'];
      if(!status){
        if(response['error'] != null){
          final error = response['error'] as Map<String,dynamic>;
          message = error.entries.first.value;
        }
      }
      CustDialog.show(context:context,message: message,);
      if(status){
        widget.onSuccess?.call();
      }
    }else{
      showSimpleSnackBar(context: context, message: 'Something went wrong !!',status: false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onRejected()async {
    _selectedAction = 'rejected';
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final response = await APIService.getInstance(context).invoiceClaim.cancelClaim(claimID: widget.claimId, claimStatus: 'rejected', remakrs: _remarkController.text);
    if(response != null){
      final status = response['isScuss'];
      String message = response['messages'];
      if(!status){
        if(response['error'] != null){
          final error = response['error'] as Map<String,dynamic>;
          message = error.entries.first.value;
        }
      }
      CustDialog.show(context:context,message: message,);
      if(status){
        widget.onSuccess?.call();
      }
    }else{
      showSimpleSnackBar(context: context, message: 'Something went wrong !!',status: false);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _onCancel()async {
    _selectedAction = 'cancel';
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final response = await APIService.getInstance(context).invoiceClaim.cancelClaim(claimID: widget.claimId, claimStatus: 'cancelled', remakrs: _remarkController.text);
    if(response != null){
      final status = response['isScuss'];
      String message = response['messages'];
      if(!status){
        if(response['error'] != null){
          final error = response['error'] as Map<String,dynamic>;
          message = error.entries.first.value;
        }
      }
      CustDialog.show(context:context,message: message,);
      if(status){
        widget.onSuccess?.call();
      }
    }else{
      showSimpleSnackBar(context: context, message: 'Something went wrong !!',status: false);
    }
    setState(() {
      _isLoading = false;
    });
  }

}
