import 'package:flutter/material.dart';
import '../models/disposal_service.dart';

class DisposalServiceCard extends StatelessWidget {
  final DisposalService service;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final bool showMaterialTypes;
  final bool isCompact;

  const DisposalServiceCard({
    super.key,
    required this.service,
    this.isFavorite = false,
    this.onTap,
    this.onFavorite,
    this.showMaterialTypes = false,
    this.isCompact = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: isCompact ? 180 : 220,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.network(
                service.serviceImgUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
            // Dark gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                  ),
                ),
              ),
            ),
            // Favorite button
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    print('[UI] Favorite icon tapped for service: ${service.serviceId}');
                    if (onFavorite != null) onFavorite!();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      isFavorite
                          ? 'assets/icons/collections_active.png'
                          : 'assets/icons/collections.png',
                      width: 20,
                      height: 20,
                      color: isFavorite ? Colors.white : const Color(0xFF4A5F44),
                    ),
                  ),
                ),
              ),
            ),



            // Content
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          service.serviceName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Mallanna',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            service.serviceRating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Mallanna',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.formattedDistance,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontFamily: 'Mallanna',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: service.isCurrentlyOpen()
                              ? const Color.fromARGB(255, 97, 170, 87)
                              : Colors.red[400],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          service.isCurrentlyOpen() ? 'Open' : 'Closed',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Mallanna',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (isCompact)
                    Text(
                      service.serviceMaterials
                              .map((m) => m.materialPoints.materialType)
                              .toSet()
                              .take(3)
                              .join(', ') +
                          (service.serviceMaterials.length > 3 ? '...' : ''),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontFamily: 'Mallanna',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  // Material Types chips (only shown in full view)
                  if (!isCompact && service.serviceMaterials.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: service.serviceMaterials
                            .map(
                              (material) =>
                                  material.materialPoints.materialType,
                            )
                            .toSet()
                            .map((materialType) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4A5F44,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF4A5F44),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  materialType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Mallanna',
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
